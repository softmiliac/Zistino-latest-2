from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from rest_framework.views import APIView
from drf_spectacular.utils import extend_schema, OpenApiExample
from zistino_apps.users.permissions import IsManager
from django.contrib.auth import get_user_model
from django.db.models import Q
from django.utils import timezone
from django.conf import settings
import logging

User = get_user_model()

from .models import (
    UserPoints, PointTransaction, ReferralCode, Referral,
    Lottery, LotteryTicket
)
from .serializers import (
    UserPointsSerializer, PointTransactionSerializer, ReferralCodeSerializer,
    ReferralSerializer, LotterySerializer, LotteryTicketSerializer,
    BuyTicketsSerializer, LotterySearchRequestSerializer,
    PointTransactionSearchRequestSerializer, ReferralSearchRequestSerializer,
    DrawWinnerSerializer
)
from zistino_apps.configurations.models import Configuration

logger = logging.getLogger(__name__)


# ============================================
# POINTS UTILITY FUNCTIONS
# ============================================

def get_points_config():
    """Get points configuration values. Default: order=1, referral=2."""
    try:
        order_config = Configuration.objects.get(name='order_points', is_active=True)
        order_points = int(order_config.value.get('amount', 1))
    except Configuration.DoesNotExist:
        order_points = 1  # Default: 1 point per order
    
    try:
        referral_config = Configuration.objects.get(name='referral_points', is_active=True)
        referral_points = int(referral_config.value.get('amount', 2))
    except Configuration.DoesNotExist:
        referral_points = 2  # Default: 2 points per referral
    
    return order_points, referral_points


def award_order_points(user, order_id):
    """
    Award points for completing an order.
    Default: 1 point per order (configurable via Configuration model).
    """
    order_points, _ = get_points_config()
    
    user_points, _ = UserPoints.objects.get_or_create(user=user)
    user_points.add_points(
        amount=order_points,
        source='order',
        description=f'Points for order {order_id}',
        reference_id=str(order_id)
    )
    return user_points.balance


def award_referral_points(referrer, referred_user, referral_id):
    """
    Award points for successful referral.
    Default: 2 points for referrer (configurable via Configuration model).
    """
    _, referral_points = get_points_config()
    
    # Award points to referrer
    referrer_points_obj, _ = UserPoints.objects.get_or_create(user=referrer)
    referrer_points_obj.add_points(
        amount=referral_points,
        source='referral',
        description=f'Referral points for referring {referred_user.phone_number}',
        reference_id=str(referral_id)
    )
    
    return referrer_points_obj.balance


# ============================================
# CUSTOMER ENDPOINTS - POINTS
# ============================================

@extend_schema(tags=['Points & Lottery'])
class CustomerPointsViewSet(viewsets.ViewSet):
    """ViewSet for customer points operations."""
    permission_classes = [IsAuthenticated]

    @extend_schema(
        tags=['Points & Lottery'],
        operation_id='points_my_balance',
        summary='Get my points balance',
        description='Get current points balance for logged-in customer.',
        responses={
            200: {
                'description': 'Points balance',
                'content': {
                    'application/json': {
                        'examples': {
                            'example1': {
                                'summary': 'User with points',
                                'value': {
                                    'balance': 150,
                                    'lifetimeEarned': 200,
                                    'lifetimeSpent': 50
                                }
                            },
                            'example2': {
                                'summary': 'New user with zero points',
                                'value': {
                                    'balance': 0,
                                    'lifetimeEarned': 0,
                                    'lifetimeSpent': 0
                                }
                            }
                        }
                    }
                }
            }
        }
    )
    @action(detail=False, methods=['get'], url_path='my-balance')
    def my_balance(self, request):
        """Get customer's current points balance."""
        user_points, _ = UserPoints.objects.get_or_create(user=request.user)
        return Response({
            'balance': user_points.balance,
            'lifetimeEarned': user_points.lifetime_earned,
            'lifetimeSpent': user_points.lifetime_spent
        })

    @extend_schema(
        tags=['Points & Lottery'],
        operation_id='points_my_history',
        summary='Get my points transaction history',
        description='Get points transaction history for logged-in customer (last 100 transactions).',
        responses={
            200: {
                'description': 'Transaction history',
                'content': {
                    'application/json': {
                        'examples': {
                            'example1': {
                                'summary': 'User with transaction history',
                                'value': {
                                    'items': [
                                        {
                                            'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                                            'userId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'userPhone': '+989121234567',
                                            'amount': 1,
                                            'transactionType': 'earned',
                                            'source': 'order',
                                            'referenceId': '46e818ce-0518-4c64-8438-27bc7163a706',
                                            'description': 'Points for order 46e818ce-0518-4c64-8438-27bc7163a706',
                                            'balanceAfter': 1,
                                            'createdAt': '2024-01-15T10:30:00Z'
                                        },
                                        {
                                            'id': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'userId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'userPhone': '+989121234567',
                                            'amount': 2,
                                            'transactionType': 'earned',
                                            'source': 'referral',
                                            'referenceId': 'abc12345-def6-7890-ghij-klmnopqrstuv',
                                            'description': 'Referral points for referring +989121234568',
                                            'balanceAfter': 3,
                                            'createdAt': '2024-01-14T09:00:00Z'
                                        }
                                    ],
                                    'total': 5
                                }
                            },
                            'example2': {
                                'summary': 'User with no transactions',
                                'value': {
                                    'items': [],
                                    'total': 0
                                }
                            }
                        }
                    }
                }
            }
        }
    )
    @action(detail=False, methods=['get'], url_path='my-history')
    def my_history(self, request):
        """Get customer's points transaction history."""
        import uuid
        
        # Prefetch referral data to avoid N+1 queries
        qs = PointTransaction.objects.filter(user=request.user).order_by('-created_at')[:100]
        
        # Get referral IDs from the queryset before evaluating it
        # Filter for valid UUIDs only
        referral_ids_raw = list(qs.filter(source='referral').exclude(reference_id='').exclude(reference_id__isnull=True).values_list('reference_id', flat=True))
        referral_ids = []
        for ref_id in referral_ids_raw:
            try:
                # Try to parse as UUID to validate
                uuid.UUID(str(ref_id))
                referral_ids.append(ref_id)
            except (ValueError, TypeError):
                # Skip invalid UUIDs
                continue
        
        referral_dict = {}
        if referral_ids:
            try:
                referrals = Referral.objects.filter(id__in=referral_ids).select_related('referred')
                referral_dict = {str(ref.id): ref for ref in referrals}
            except Exception as e:
                logger.warning(f"Error prefetching referrals: {str(e)}")
                referral_dict = {}
        
        # Convert queryset to list and attach cached referrals
        transactions_list = list(qs)
        for transaction in transactions_list:
            if transaction.source == 'referral' and transaction.reference_id:
                try:
                    transaction._cached_referral = referral_dict.get(str(transaction.reference_id))
                except Exception as e:
                    logger.warning(f"Error attaching cached referral for transaction {transaction.id}: {str(e)}")
        
        serializer = PointTransactionSerializer(transactions_list, many=True)
        return Response({
            'items': serializer.data,
            'total': PointTransaction.objects.filter(user=request.user).count()
        })


# ============================================
# CUSTOMER ENDPOINTS - REFERRALS
# ============================================

@extend_schema(tags=['Points & Lottery'])
class CustomerReferralViewSet(viewsets.ViewSet):
    """ViewSet for customer referral operations."""
    permission_classes = [IsAuthenticated]

    @extend_schema(
        tags=['Points & Lottery'],
        operation_id='referral_my_code',
        summary='Get my referral code',
        description='Get or create referral code for logged-in customer. Share this code with friends to earn referral points.',
        responses={
            200: {
                'description': 'Referral code',
                'content': {
                    'application/json': {
                        'examples': {
                            'example1': {
                                'summary': 'Referral code with share URL',
                                'value': {
                                    'code': 'ABC12345',
                                    'shareUrl': 'https://app.com/register?ref=ABC12345'
                                }
                            },
                            'example2': {
                                'summary': 'Another referral code',
                                'value': {
                                    'code': 'XYZ98765',
                                    'shareUrl': 'https://app.com/register?ref=XYZ98765'
                                }
                            }
                        }
                    }
                }
            }
        }
    )
    @action(detail=False, methods=['get'], url_path='my-code')
    def my_code(self, request):
        """Get or create referral code for customer."""
        code_obj = ReferralCode.get_or_create_for_user(request.user)
        return Response({
            'code': code_obj.code,
            'shareUrl': f"{getattr(settings, 'FRONTEND_URL', 'https://app.com')}/register?ref={code_obj.code}"
        })

    @extend_schema(
        tags=['Points & Lottery'],
        operation_id='referral_my_referrals',
        summary='Get my referrals',
        description='Get list of people I referred. Shows referral status and whether points were awarded.',
        responses={
            200: {
                'description': 'List of referrals',
                'content': {
                    'application/json': {
                        'examples': {
                            'example1': {
                                'summary': 'User with referrals',
                                'value': {
                                    'items': [
                                        {
                                            'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                                            'referrerId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'referrerPhone': '+989121234567',
                                            'referrerName': 'John Doe',
                                            'referredId': 'abc12345-def6-7890-ghij-klmnopqrstuv',
                                            'referredPhone': '+989121234568',
                                            'referredName': 'Jane Smith',
                                            'referral_code': 'ABC12345',
                                            'status': 'completed',
                                            'referrerPointsAwarded': True,
                                            'referredBonusAwarded': False,
                                            'completedAt': '2024-01-15T10:30:00Z',
                                            'createdAt': '2024-01-14T09:00:00Z'
                                        },
                                        {
                                            'id': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'referrerId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'referrerPhone': '+989121234567',
                                            'referrerName': 'John Doe',
                                            'referredId': 'xyz98765-4321-fedc-ba09-876543210fed',
                                            'referredPhone': '+989121234569',
                                            'referredName': 'Bob Wilson',
                                            'referral_code': 'ABC12345',
                                            'status': 'pending',
                                            'referrerPointsAwarded': False,
                                            'referredBonusAwarded': False,
                                            'completedAt': None,
                                            'createdAt': '2024-01-16T08:00:00Z'
                                        }
                                    ],
                                    'total': 3
                                }
                            },
                            'example2': {
                                'summary': 'User with no referrals',
                                'value': {
                                    'items': [],
                                    'total': 0
                                }
                            }
                        }
                    }
                }
            }
        }
    )
    @action(detail=False, methods=['get'], url_path='my-referrals')
    def my_referrals(self, request):
        """Get list of people customer referred."""
        qs = Referral.objects.filter(referrer=request.user).order_by('-created_at')
        serializer = ReferralSerializer(qs, many=True)
        return Response({
            'items': serializer.data,
            'total': qs.count()
        })


# ============================================
# CUSTOMER ENDPOINTS - LOTTERY
# ============================================

@extend_schema(tags=['Points & Lottery'])
class CustomerLotteryViewSet(viewsets.ViewSet):
    """ViewSet for customer lottery operations."""
    permission_classes = [IsAuthenticated]

    @extend_schema(
        tags=['Points & Lottery'],
        operation_id='lottery_active',
        summary='Get active lotteries',
        description='Get list of active lotteries that customers can participate in. Only shows lotteries with status="active" and within start/end date range.',
        responses={
            200: {
                'description': 'List of active lotteries',
                'content': {
                    'application/json': {
                        'examples': {
                            'example1': {
                                'summary': 'Active lotteries available',
                                'value': {
                                    'items': [
                                        {
                                            'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                                            'title': 'Monthly Prize Draw',
                                            'description': 'Win an amazing Electric Scooter! Participate now!',
                                            'prizeName': 'Electric Scooter',
                                            'prizeImage': 'https://example.com/images/scooter.jpg',
                                            'ticketPricePoints': 100,
                                            'status': 'active',
                                            'startDate': '2024-01-01T00:00:00Z',
                                            'endDate': '2024-12-31T23:59:59Z',
                                            'totalTickets': 150,
                                            'totalParticipants': 50,
                                            'winnerId': None,
                                            'winnerName': None,
                                            'createdAt': '2024-01-01T00:00:00Z'
                                        },
                                        {
                                            'id': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'title': 'Holiday Special',
                                            'description': 'Special holiday lottery!',
                                            'prizeName': 'Smartphone',
                                            'prizeImage': 'https://example.com/images/phone.jpg',
                                            'ticketPricePoints': 200,
                                            'status': 'active',
                                            'startDate': '2024-12-01T00:00:00Z',
                                            'endDate': '2024-12-31T23:59:59Z',
                                            'totalTickets': 75,
                                            'totalParticipants': 30,
                                            'winnerId': None,
                                            'winnerName': None,
                                            'createdAt': '2024-11-15T10:00:00Z'
                                        }
                                    ],
                                    'total': 2
                                }
                            },
                            'example2': {
                                'summary': 'No active lotteries',
                                'value': {
                                    'items': [],
                                    'total': 0
                                }
                            }
                        }
                    }
                }
            }
        }
    )
    @action(detail=False, methods=['get'], url_path='active')
    def active(self, request):
        """Get active lotteries."""
        now = timezone.now()
        qs = Lottery.objects.filter(
            status='active',
            start_date__lte=now,
            end_date__gte=now
        ).order_by('-created_at')
        serializer = LotterySerializer(qs, many=True)
        return Response({
            'items': serializer.data,
            'total': qs.count()
        })

    @extend_schema(
        tags=['Points & Lottery'],
        operation_id='lottery_retrieve',
        summary='Get lottery details',
        description='Get details of a specific lottery. Customer can view any lottery details.',
        responses={
            200: {
                'description': 'Lottery details',
                'content': {
                    'application/json': {
                        'examples': {
                            'example1': {
                                'summary': 'Active lottery details',
                                'value': {
                                    'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                                    'title': 'Monthly Prize Draw',
                                    'description': 'Win an amazing Electric Scooter! Participate now!',
                                    'prizeName': 'Electric Scooter',
                                    'prizeImage': 'https://example.com/images/scooter.jpg',
                                    'ticketPricePoints': 100,
                                    'status': 'active',
                                    'startDate': '2024-01-01T00:00:00Z',
                                    'endDate': '2024-12-31T23:59:59Z',
                                    'totalTickets': 150,
                                    'totalParticipants': 50,
                                    'winnerId': None,
                                    'winnerName': None,
                                    'winnerTicketId': None,
                                    'drawnAt': None,
                                    'createdById': None,
                                    'createdAt': '2024-01-01T00:00:00Z',
                                    'updatedAt': '2024-01-15T10:00:00Z'
                                }
                            },
                            'example2': {
                                'summary': 'Drawn lottery with winner',
                                'value': {
                                    'id': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                    'title': 'January Prize Draw',
                                    'prizeName': 'Smartphone',
                                    'status': 'drawn',
                                    'winnerId': 'abc12345-def6-7890-ghij-klmnopqrstuv',
                                    'winnerName': 'Jane Smith',
                                    'winnerTicketId': 'xyz98765-4321-fedc-ba09-876543210fed',
                                    'drawnAt': '2024-01-15T12:00:00Z',
                                    'totalTickets': 200,
                                    'totalParticipants': 75
                                }
                            }
                        }
                    }
                }
            },
            404: {
                'description': 'Lottery not found',
                'content': {
                    'application/json': {
                        'example': {
                            'detail': 'Not found'
                        }
                    }
                }
            }
        }
    )
    def retrieve(self, request, pk=None):
        """Get lottery details."""
        try:
            lottery = Lottery.objects.get(pk=pk)
        except Lottery.DoesNotExist:
            return Response(
                {'detail': 'Not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        return Response(LotterySerializer(lottery).data)

    @extend_schema(
        tags=['Points & Lottery'],
        operation_id='lottery_buy_tickets',
        summary='Buy lottery tickets',
        description='Buy lottery tickets using points. Points will be deducted from balance.',
        request=BuyTicketsSerializer,
        examples=[
            OpenApiExample(
                'Buy 5 tickets',
                value={
                    'ticket_count': 5
                }
            ),
            OpenApiExample(
                'Buy 1 ticket',
                value={
                    'ticket_count': 1
                }
            )
        ],
        responses={
            200: {
                'description': 'Tickets purchased successfully',
                'content': {
                    'application/json': {
                        'examples': {
                            'example1': {
                                'summary': 'Successfully purchased 5 tickets',
                                'value': {
                                    'ticket_id': '46e818ce-0518-4c64-8438-27bc7163a706',
                                    'ticket_count': 5,
                                    'points_spent': 500,
                                    'remaining_balance': 450
                                }
                            },
                            'example2': {
                                'summary': 'Purchased 1 ticket',
                                'value': {
                                    'ticket_id': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                    'ticket_count': 1,
                                    'points_spent': 100,
                                    'remaining_balance': 50
                                }
                            }
                        }
                    }
                }
            },
            400: {
                'description': 'Bad request',
                'content': {
                    'application/json': {
                        'examples': {
                            'example1': {
                                'summary': 'Insufficient points',
                                'value': {
                                    'detail': 'Insufficient points. Need 500, have 300'
                                }
                            },
                            'example2': {
                                'summary': 'Lottery not active',
                                'value': {
                                    'detail': 'Lottery is not active',
                                    'reasons': [
                                        "Status is 'draft' (must be 'active')",
                                        "Start date is in the future: 2024-12-31T00:00:00Z"
                                    ],
                                    'current_status': 'draft',
                                    'start_date': '2024-12-31T00:00:00Z',
                                    'end_date': '2025-12-31T23:59:59Z',
                                    'current_time': '2024-01-15T10:30:00Z'
                                }
                            }
                        }
                    }
                }
            },
            404: {
                'description': 'Lottery not found',
                'content': {
                    'application/json': {
                        'example': {
                            'detail': 'Lottery not found'
                        }
                    }
                }
            }
        }
    )
    @action(detail=True, methods=['post'], url_path='buy-tickets')
    def buy_tickets(self, request, pk=None):
        """Buy lottery tickets using points."""
        try:
            lottery = Lottery.objects.get(pk=pk)
        except Lottery.DoesNotExist:
            return Response(
                {'detail': 'Lottery not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Check if lottery is active
        now = timezone.now()
        issues = []
        if lottery.status != 'active':
            issues.append(f"Status is '{lottery.status}' (must be 'active')")
        if lottery.start_date > now:
            issues.append(f"Start date is in the future: {lottery.start_date}")
        if lottery.end_date < now:
            issues.append(f"End date has passed: {lottery.end_date}")
        
        if issues:
            return Response(
                {
                    'detail': 'Lottery is not active',
                    'reasons': issues,
                    'current_status': lottery.status,
                    'start_date': lottery.start_date.isoformat() if lottery.start_date else None,
                    'end_date': lottery.end_date.isoformat() if lottery.end_date else None,
                    'current_time': now.isoformat()
                },
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Validate request
        serializer = BuyTicketsSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        ticket_count = serializer.validated_data['ticket_count']
        
        # Calculate points needed
        points_needed = ticket_count * lottery.ticket_price_points
        
        # Get user points
        user_points, _ = UserPoints.objects.get_or_create(user=request.user)
        
        # Check balance
        if user_points.balance < points_needed:
            return Response(
                {'detail': f'Insufficient points. Need {points_needed}, have {user_points.balance}'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Deduct points
        user_points.spend_points(
            amount=points_needed,
            source='lottery',
            description=f'Purchased {ticket_count} ticket(s) for lottery: {lottery.title}',
            reference_id=str(lottery.id)
        )
        
        # Create lottery ticket
        ticket = LotteryTicket.objects.create(
            lottery=lottery,
            user=request.user,
            ticket_count=ticket_count,
            points_spent=points_needed
        )
        
        return Response({
            'ticket_id': str(ticket.id),
            'ticket_count': ticket_count,
            'points_spent': points_needed,
            'remaining_balance': user_points.balance
        }, status=status.HTTP_200_OK)

    @extend_schema(
        tags=['Points & Lottery'],
        operation_id='lottery_my_tickets',
        summary='Get my lottery tickets',
        description='Get all lottery tickets purchased by logged-in customer across all lotteries.',
        responses={
            200: {
                'description': 'List of tickets',
                'content': {
                    'application/json': {
                        'examples': {
                            'example1': {
                                'summary': 'User with tickets',
                                'value': {
                                    'items': [
                                        {
                                            'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                                            'lotteryId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'lotteryTitle': 'Monthly Prize Draw',
                                            'lotteryPrizeName': 'Electric Scooter',
                                            'userId': 'abc12345-def6-7890-ghij-klmnopqrstuv',
                                            'userPhone': '+989121234567',
                                            'ticketCount': 5,
                                            'pointsSpent': 500,
                                            'purchaseDate': '2024-01-15T10:30:00Z',
                                            'isWinner': False
                                        },
                                        {
                                            'id': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'lotteryId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'lotteryTitle': 'Monthly Prize Draw',
                                            'lotteryPrizeName': 'Electric Scooter',
                                            'userId': 'abc12345-def6-7890-ghij-klmnopqrstuv',
                                            'userPhone': '+989121234567',
                                            'ticketCount': 3,
                                            'pointsSpent': 300,
                                            'purchaseDate': '2024-01-14T09:00:00Z',
                                            'isWinner': False
                                        },
                                        {
                                            'id': 'xyz98765-4321-fedc-ba09-876543210fed',
                                            'lotteryId': '46e818ce-0518-4c64-8438-27bc7163a706',
                                            'lotteryTitle': 'Holiday Special',
                                            'lotteryPrizeName': 'Smartphone',
                                            'userId': 'abc12345-def6-7890-ghij-klmnopqrstuv',
                                            'userPhone': '+989121234567',
                                            'ticketCount': 1,
                                            'pointsSpent': 200,
                                            'purchaseDate': '2024-01-13T08:00:00Z',
                                            'isWinner': True
                                        }
                                    ],
                                    'total': 10
                                }
                            },
                            'example2': {
                                'summary': 'User with no tickets',
                                'value': {
                                    'items': [],
                                    'total': 0
                                }
                            }
                        }
                    }
                }
            }
        }
    )
    @action(detail=False, methods=['get'], url_path='my-tickets')
    def my_tickets(self, request):
        """Get customer's lottery tickets."""
        qs = LotteryTicket.objects.filter(user=request.user).order_by('-purchase_date')
        serializer = LotteryTicketSerializer(qs, many=True)
        return Response({
            'items': serializer.data,
            'total': qs.count()
        })

    @extend_schema(
        tags=['Points & Lottery'],
        operation_id='lottery_winners',
        summary='Get past lottery winners',
        description='Get list of past lottery winners. Shows lotteries that have been drawn and have a winner.',
        responses={
            200: {
                'description': 'List of winners',
                'content': {
                    'application/json': {
                        'examples': {
                            'example1': {
                                'summary': 'Past winners list',
                                'value': {
                                    'items': [
                                        {
                                            'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                                            'title': 'Monthly Prize Draw - January',
                                            'description': 'January monthly lottery',
                                            'prizeName': 'Electric Scooter',
                                            'prizeImage': 'https://example.com/images/scooter.jpg',
                                            'ticketPricePoints': 100,
                                            'status': 'drawn',
                                            'startDate': '2024-01-01T00:00:00Z',
                                            'endDate': '2024-01-31T23:59:59Z',
                                            'winnerId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'winnerName': 'John Doe',
                                            'winnerTicketId': 'abc12345-def6-7890-ghij-klmnopqrstuv',
                                            'drawnAt': '2024-02-01T10:30:00Z',
                                            'totalTickets': 200,
                                            'totalParticipants': 75,
                                            'createdAt': '2024-01-01T00:00:00Z'
                                        },
                                        {
                                            'id': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'title': 'Holiday Special',
                                            'prizeName': 'Smartphone',
                                            'status': 'drawn',
                                            'winnerId': 'xyz98765-4321-fedc-ba09-876543210fed',
                                            'winnerName': 'Jane Smith',
                                            'drawnAt': '2024-01-15T12:00:00Z',
                                            'totalTickets': 150,
                                            'totalParticipants': 50
                                        }
                                    ],
                                    'total': 5
                                }
                            },
                            'example2': {
                                'summary': 'No winners yet',
                                'value': {
                                    'items': [],
                                    'total': 0
                                }
                            }
                        }
                    }
                }
            }
        }
    )
    @action(detail=False, methods=['get'], url_path='winners')
    def winners(self, request):
        """Get past lottery winners."""
        qs = Lottery.objects.filter(status='drawn', winner__isnull=False).order_by('-drawn_at')
        serializer = LotterySerializer(qs, many=True)
        return Response({
            'items': serializer.data,
            'total': qs.count()
        })


# ============================================
# ADMIN/MANAGER ENDPOINTS - LOTTERY MANAGEMENT
# ============================================

@extend_schema(tags=['Admin'])
class AdminLotteryViewSet(viewsets.ModelViewSet):
    """ViewSet for admin lottery management."""
    queryset = Lottery.objects.all()
    serializer_class = LotterySerializer
    permission_classes = [IsAuthenticated, IsManager]

    def get_queryset(self):
        """Return all lotteries for admin."""
        return Lottery.objects.all().order_by('-created_at')

    @extend_schema(
        tags=['Admin'],
        operation_id='lottery_create',
        request=LotterySerializer,
        examples=[
            OpenApiExample(
                'Create active lottery',
                value={
                    'title': 'Monthly Prize Draw',
                    'description': 'Win an amazing Electric Scooter! Participate now!',
                    'prizeName': 'Electric Scooter',
                    'prizeImage': 'https://example.com/images/scooter.jpg',
                    'ticketPricePoints': 100,
                    'status': 'active',
                    'startDate': '2024-01-01T00:00:00Z',
                    'endDate': '2024-12-31T23:59:59Z'
                }
            ),
            OpenApiExample(
                'Create draft lottery',
                value={
                    'title': 'New Year Special',
                    'description': 'Special lottery for new year',
                    'prizeName': 'Smartphone',
                    'prizeImage': 'https://example.com/images/phone.jpg',
                    'ticketPricePoints': 200,
                    'status': 'draft',
                    'startDate': '2025-01-01T00:00:00Z',
                    'endDate': '2025-01-31T23:59:59Z'
                }
            )
        ],
        responses={
            201: {
                'description': 'Lottery created successfully',
                'content': {
                    'application/json': {
                        'example': {
                            'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                            'title': 'Monthly Prize Draw',
                            'prizeName': 'Electric Scooter',
                            'ticketPricePoints': 100,
                            'status': 'active',
                            'totalTickets': 0,
                            'totalParticipants': 0,
                            'createdAt': '2024-01-15T10:30:00Z'
                        }
                    }
                }
            }
        }
    )
    def create(self, request, *args, **kwargs):
        """Create a new lottery. Manager must be authenticated."""
        # Set created_by to current user
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        lottery = serializer.save(created_by=request.user)
        return Response(LotterySerializer(lottery).data, status=status.HTTP_201_CREATED)

    @extend_schema(
        tags=['Admin'],
        operation_id='lottery_list',
        summary='List all lotteries',
        description='Get list of all lotteries (admin only).',
        responses={
            200: {
                'description': 'List of lotteries',
                'content': {
                    'application/json': {
                        'example': {
                            'items': [
                                {
                                    'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                                    'title': 'Monthly Prize Draw',
                                    'prizeName': 'Electric Scooter',
                                    'status': 'active',
                                    'ticketPricePoints': 100,
                                    'totalTickets': 150,
                                    'totalParticipants': 50
                                }
                            ]
                        }
                    }
                }
            }
        }
    )
    def list(self, request, *args, **kwargs):
        """List all lotteries for admin."""
        queryset = self.filter_queryset(self.get_queryset())
        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)
        serializer = self.get_serializer(queryset, many=True)
        return Response({'items': serializer.data})

    @extend_schema(
        tags=['Admin'],
        operation_id='lottery_retrieve_admin',
        summary='Get lottery details',
        description='Get details of a specific lottery (admin).',
        responses={
            200: {
                'description': 'Lottery details',
                'content': {
                    'application/json': {
                        'example': {
                            'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                            'title': 'Monthly Prize Draw',
                            'description': 'Win an amazing Electric Scooter!',
                            'prizeName': 'Electric Scooter',
                            'prizeImage': 'https://example.com/images/scooter.jpg',
                            'ticketPricePoints': 100,
                            'status': 'active',
                            'startDate': '2024-01-01T00:00:00Z',
                            'endDate': '2024-12-31T23:59:59Z',
                            'totalTickets': 150,
                            'totalParticipants': 50,
                            'winnerId': None,
                            'winnerName': None,
                            'createdAt': '2024-01-15T10:30:00Z'
                        }
                    }
                }
            },
            404: {
                'description': 'Lottery not found',
                'content': {
                    'application/json': {
                        'example': {
                            'detail': 'Not found.'
                        }
                    }
                }
            }
        }
    )
    def retrieve(self, request, *args, **kwargs):
        """Get lottery details."""
        return super().retrieve(request, *args, **kwargs)

    @extend_schema(
        tags=['Admin'],
        operation_id='lottery_update',
        request=LotterySerializer,
        examples=[
            OpenApiExample(
                'Update lottery - full',
                value={
                    'title': 'Monthly Prize Draw - Updated',
                    'description': 'Updated description',
                    'prizeName': 'Electric Scooter Pro',
                    'prizeImage': 'https://example.com/images/scooter-pro.jpg',
                    'ticketPricePoints': 150,
                    'status': 'active',
                    'startDate': '2024-01-01T00:00:00Z',
                    'endDate': '2024-12-31T23:59:59Z'
                }
            ),
            OpenApiExample(
                'Update lottery - change status',
                value={
                    'status': 'ended'
                }
            )
        ],
        responses={
            200: {
                'description': 'Lottery updated successfully',
                'content': {
                    'application/json': {
                        'example': {
                            'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                            'title': 'Monthly Prize Draw - Updated',
                            'status': 'active',
                            'updatedAt': '2024-01-15T11:00:00Z'
                        }
                    }
                }
            }
        }
    )
    def update(self, request, *args, **kwargs):
        """Update lottery (full update)."""
        return super().update(request, *args, **kwargs)

    @extend_schema(
        tags=['Admin'],
        operation_id='lottery_partial_update',
        request=LotterySerializer,
        examples=[
            OpenApiExample(
                'Update only status',
                value={
                    'status': 'active'
                }
            ),
            OpenApiExample(
                'Update ticket price',
                value={
                    'ticketPricePoints': 150
                }
            ),
            OpenApiExample(
                'Update end date',
                value={
                    'endDate': '2025-01-31T23:59:59Z'
                }
            )
        ],
        responses={
            200: {
                'description': 'Lottery partially updated',
                'content': {
                    'application/json': {
                        'example': {
                            'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                            'status': 'active',
                            'ticketPricePoints': 150
                        }
                    }
                }
            }
        }
    )
    def partial_update(self, request, *args, **kwargs):
        """Partially update lottery."""
        return super().partial_update(request, *args, **kwargs)

    @extend_schema(
        tags=['Admin'],
        operation_id='lottery_delete',
        summary='Delete lottery',
        description='Delete a lottery (admin only).',
        responses={
            204: {
                'description': 'Lottery deleted successfully'
            },
            404: {
                'description': 'Lottery not found',
                'content': {
                    'application/json': {
                        'example': {
                            'detail': 'Not found.'
                        }
                    }
                }
            }
        }
    )
    def destroy(self, request, *args, **kwargs):
        """Delete lottery."""
        return super().destroy(request, *args, **kwargs)

    @extend_schema(
        tags=['Admin'],
        operation_id='lottery_search',
        summary='Search lotteries',
        description='Admin search endpoint for lotteries with pagination and status filtering.',
        request=LotterySearchRequestSerializer,
        examples=[
            OpenApiExample(
                'Search all lotteries',
                value={
                    'pageNumber': 1,
                    'pageSize': 20,
                    'status': ''
                }
            ),
            OpenApiExample(
                'Search active lotteries',
                value={
                    'pageNumber': 1,
                    'pageSize': 20,
                    'status': 'active'
                }
            ),
            OpenApiExample(
                'Search draft lotteries',
                value={
                    'pageNumber': 1,
                    'pageSize': 20,
                    'status': 'draft'
                }
            ),
            OpenApiExample(
                'Search drawn lotteries',
                value={
                    'pageNumber': 1,
                    'pageSize': 20,
                    'status': 'drawn'
                }
            )
        ],
        responses={
            200: {
                'description': 'List of lotteries',
                'content': {
                    'application/json': {
                        'example': {
                            'items': [
                                {
                                    'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                                    'title': 'Monthly Prize Draw',
                                    'description': 'Win an amazing Electric Scooter!',
                                    'prizeName': 'Electric Scooter',
                                    'prizeImage': 'https://example.com/images/scooter.jpg',
                                    'ticketPricePoints': 100,
                                    'status': 'active',
                                    'startDate': '2024-01-01T00:00:00Z',
                                    'endDate': '2024-12-31T23:59:59Z',
                                    'totalTickets': 150,
                                    'totalParticipants': 50,
                                    'winnerId': None,
                                    'winnerName': None,
                                    'createdAt': '2024-01-15T10:30:00Z'
                                }
                            ],
                            'pageNumber': 1,
                            'pageSize': 20,
                            'total': 5
                        }
                    }
                }
            }
        }
    )
    @action(detail=False, methods=['post'], url_path='search')
    def search(self, request):
        """Admin search endpoint for lotteries with pagination and status filter."""
        serializer = LotterySearchRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        page_number = serializer.validated_data.get('pageNumber', 1)
        page_size = serializer.validated_data.get('pageSize', 20)
        status_filter = serializer.validated_data.get('status', '').strip()
        
        qs = Lottery.objects.all().order_by('-created_at')
        
        # Filter by status if provided
        if status_filter:
            qs = qs.filter(status=status_filter)
        
        start = (page_number - 1) * page_size
        end = start + page_size
        items = qs[start:end]
        
        return Response({
            'items': LotterySerializer(items, many=True).data,
            'pageNumber': page_number,
            'pageSize': page_size,
            'total': qs.count(),
        })

    @extend_schema(
        tags=['Admin'],
        operation_id='lottery_participants',
        summary='Get lottery participants',
        description='Get all participants (tickets) for a specific lottery. Shows who bought tickets and how many.',
        responses={
            200: {
                'description': 'List of participants',
                'content': {
                    'application/json': {
                        'examples': {
                            'example1': {
                                'summary': 'Lottery with participants',
                                'value': {
                                    'items': [
                                        {
                                            'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                                            'lotteryId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'lotteryTitle': 'Monthly Prize Draw',
                                            'lotteryPrizeName': 'Electric Scooter',
                                            'userId': 'abc12345-def6-7890-ghij-klmnopqrstuv',
                                            'userPhone': '+989121234567',
                                            'ticketCount': 5,
                                            'pointsSpent': 500,
                                            'purchaseDate': '2024-01-15T10:30:00Z',
                                            'isWinner': False
                                        },
                                        {
                                            'id': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'lotteryId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'lotteryTitle': 'Monthly Prize Draw',
                                            'lotteryPrizeName': 'Electric Scooter',
                                            'userId': 'xyz98765-4321-fedc-ba09-876543210fed',
                                            'userPhone': '+989121234568',
                                            'ticketCount': 10,
                                            'pointsSpent': 1000,
                                            'purchaseDate': '2024-01-14T09:00:00Z',
                                            'isWinner': True
                                        },
                                        {
                                            'id': 'pqr45678-9012-3456-7890-abcdefghijkl',
                                            'lotteryId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                            'lotteryTitle': 'Monthly Prize Draw',
                                            'lotteryPrizeName': 'Electric Scooter',
                                            'userId': 'mnop5678-9012-3456-7890-qrstuvwxyzab',
                                            'userPhone': '+989121234569',
                                            'ticketCount': 3,
                                            'pointsSpent': 300,
                                            'purchaseDate': '2024-01-13T08:00:00Z',
                                            'isWinner': False
                                        }
                                    ],
                                    'total': 50
                                }
                            },
                            'example2': {
                                'summary': 'Lottery with no participants',
                                'value': {
                                    'items': [],
                                    'total': 0
                                }
                            }
                        }
                    }
                }
            },
            404: {
                'description': 'Lottery not found',
                'content': {
                    'application/json': {
                        'example': {
                            'detail': 'Not found.'
                        }
                    }
                }
            }
        }
    )
    @action(detail=True, methods=['get'], url_path='participants')
    def participants(self, request, pk=None):
        """Get all participants for a lottery."""
        lottery = self.get_object()
        qs = LotteryTicket.objects.filter(lottery=lottery).select_related('user').order_by('-purchase_date')
        serializer = LotteryTicketSerializer(qs, many=True)
        return Response({
            'items': serializer.data,
            'total': qs.count()
        })

    @extend_schema(
        tags=['Admin'],
        operation_id='lottery_draw_winner',
        summary='Draw lottery winner',
        description='Draw winner for a lottery. Can be random or manual selection.',
        request=DrawWinnerSerializer,
        examples=[
            OpenApiExample(
                'Random draw',
                value={
                    'method': 'random'
                }
            ),
            OpenApiExample(
                'Manual draw',
                value={
                    'method': 'manual',
                    'winner_ticket_id': 'uuid-of-ticket'
                }
            )
        ],
        responses={
            200: {
                'description': 'Winner drawn successfully',
                'content': {
                    'application/json': {
                        'example': {
                            'lottery_id': 'uuid',
                            'winner_id': 'uuid',
                            'winner_name': 'John Doe',
                            'winner_phone': '+989121234567',
                            'ticket_id': 'uuid',
                            'drawn_at': '2024-01-15T10:30:00Z'
                        }
                    }
                }
            },
            400: {
                'description': 'Bad request',
                'content': {
                    'application/json': {
                        'example': {
                            'detail': 'Lottery has no tickets'
                        }
                    }
                }
            }
        }
    )
    @extend_schema(
        tags=['Admin'],
        operation_id='lottery_eligible_drivers',
        summary='Get eligible drivers for lottery',
        description='Get list of eligible drivers (based on points) for a lottery. Used to show drivers before drawing winner.',
        parameters=[
            OpenApiExample(
                'Get eligible drivers',
                value={
                    'min_points': 0
                }
            )
        ],
        responses={
            200: {
                'description': 'List of eligible drivers',
                'content': {
                    'application/json': {
                        'example': {
                            'items': [
                                {
                                    'userId': 'uuid',
                                    'userPhone': '+989121234567',
                                    'userName': 'John Doe',
                                    'points': 1500,
                                    'isEligible': True
                                }
                            ],
                            'total': 25
                        }
                    }
                }
            }
        }
    )
    @action(detail=True, methods=['get'], url_path='eligible-drivers')
    def eligible_drivers(self, request, pk=None):
        """Get eligible drivers for lottery based on points."""
        from django.db.models import F, Case, When, IntegerField, Value
        
        lottery = self.get_object()
        
        # Get minimum points threshold from query params (optional, defaults to 1)
        min_points = request.query_params.get('min_points', 1)
        try:
            min_points = int(min_points)
        except (ValueError, TypeError):
            min_points = 1
        
        # Get all active drivers and annotate with their points balance (defaulting to 0 if no UserPoints record)
        eligible_drivers = User.objects.filter(
            is_driver=True,
            is_active=True,
            is_active_driver=True
        ).annotate(
            points_balance=Case(
                When(user_points__isnull=False, then=F('user_points__balance')),
                default=Value(0),
                output_field=IntegerField()
            )
        ).filter(
            points_balance__gte=min_points
        ).select_related('user_points').distinct().order_by('-points_balance')
        
        # Serialize driver data
        drivers_data = []
        for driver in eligible_drivers:
            # Use annotated points_balance if available, otherwise fallback to user_points.balance or 0
            points = getattr(driver, 'points_balance', None)
            if points is None:
                points = driver.user_points.balance if hasattr(driver, 'user_points') and driver.user_points else 0
            drivers_data.append({
                'userId': str(driver.id),
                'userPhone': driver.phone_number,
                'userName': f"{driver.first_name} {driver.last_name}".strip() or driver.phone_number,
                'points': points,
                'isEligible': True
            })
        
        return Response({
            'items': drivers_data,
            'total': len(drivers_data),
            'min_points': min_points,
            'lottery_id': str(lottery.id)
        }, status=status.HTTP_200_OK)

    @action(detail=True, methods=['post'], url_path='draw-winner')
    def draw_winner(self, request, pk=None):
        """Draw winner for lottery from eligible drivers based on points."""
        import random as random_module
        
        lottery = self.get_object()
        
        # Get minimum points threshold from request (optional, defaults to 1)
        min_points = request.data.get('min_points', 1)
        try:
            min_points = int(min_points)
        except (ValueError, TypeError):
            min_points = 1
        
        # Get eligible drivers (drivers with points >= min_points)
        from zistino_apps.points.models import UserPoints
        from django.db.models import F, Case, When, IntegerField, Value
        
        eligible_drivers = User.objects.filter(
            is_driver=True,
            is_active=True,
            is_active_driver=True
        ).annotate(
            points_balance=Case(
                When(user_points__isnull=False, then=F('user_points__balance')),
                default=Value(0),
                output_field=IntegerField()
            )
        ).filter(
            points_balance__gte=min_points
        ).select_related('user_points').distinct()
        
        if not eligible_drivers.exists():
            return Response(
                {'detail': f'No eligible drivers found with points >= {min_points}'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Validate request
        serializer = DrawWinnerSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        method = serializer.validated_data.get('method', 'random')
        winner_user_id = serializer.validated_data.get('winner_user_id')  # Changed from winner_ticket_id
        
        if method == 'manual':
            if not winner_user_id:
                return Response(
                    {'detail': 'winner_user_id is required for manual draw'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            try:
                winner_user = eligible_drivers.get(id=winner_user_id)
            except User.DoesNotExist:
                return Response(
                    {'detail': 'Driver not found or not eligible for this lottery'},
                    status=status.HTTP_404_NOT_FOUND
                )
        else:  # random
            # Weight drivers by their points balance (more points = higher chance)
            driver_list = []
            for driver in eligible_drivers:
                # Use annotated points_balance if available, otherwise fallback to user_points.balance or 0
                points = getattr(driver, 'points_balance', None)
                if points is None:
                    points = driver.user_points.balance if hasattr(driver, 'user_points') and driver.user_points else 0
                # Add driver multiple times based on points (weighted selection)
                # Use square root to reduce extreme weighting
                weight = max(1, int((points / 100) ** 0.5)) if points > 0 else 1
                for _ in range(weight):
                    driver_list.append(driver)
            
            if not driver_list:
                return Response(
                    {'detail': 'No eligible drivers available for random selection'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            winner_user = random_module.choice(driver_list)
        
        # Update lottery
        lottery.winner = winner_user
        lottery.winner_ticket_id = None  # No tickets in this system
        lottery.status = 'drawn'
        lottery.drawn_at = timezone.now()
        lottery.save()
        
        # Send SMS notification to winner
        sms_success = False
        try:
            from zistino_apps.payments.sms_service import send_sms
            winner_name = f"{winner_user.first_name} {winner_user.last_name}".strip() or winner_user.phone_number
            message = f"شما برنده هستید! قرعه کشی: {lottery.title}"
            sms_success, sms_error = send_sms(winner_user.phone_number, message)
            if not sms_success:
                # Log error but don't fail the draw
                logger.warning(f"Failed to send SMS to lottery winner {winner_user.phone_number}: {sms_error}")
        except Exception as e:
            # Log error but don't fail the draw
            logger.error(f"Error sending SMS to lottery winner: {str(e)}", exc_info=True)
        
        return Response({
            'lottery_id': str(lottery.id),
            'winner_id': str(winner_user.id),
            'winner_name': f"{winner_user.first_name} {winner_user.last_name}".strip() or winner_user.phone_number,
            'winner_phone': winner_user.phone_number,
            'winner_points': getattr(winner_user, 'points_balance', None) or (winner_user.user_points.balance if hasattr(winner_user, 'user_points') and winner_user.user_points else 0),
            'drawn_at': lottery.drawn_at.isoformat(),
            'sms_sent': sms_success
        }, status=status.HTTP_200_OK)

    @extend_schema(
        tags=['Admin'],
        operation_id='lottery_end',
        summary='End lottery manually',
        description='Manually end a lottery (before drawing winner). Sets status to "ended".',
        responses={
            200: {
                'description': 'Lottery ended successfully',
                'content': {
                    'application/json': {
                        'example': {
                            'detail': 'Lottery ended successfully',
                            'lottery': {
                                'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                                'title': 'Monthly Prize Draw',
                                'status': 'ended',
                                'totalTickets': 150,
                                'totalParticipants': 50
                            }
                        }
                    }
                }
            },
            400: {
                'description': 'Bad request',
                'content': {
                    'application/json': {
                        'example': {
                            'detail': 'Lottery already has a winner'
                        }
                    }
                }
            },
            404: {
                'description': 'Lottery not found',
                'content': {
                    'application/json': {
                        'example': {
                            'detail': 'Not found.'
                        }
                    }
                }
            }
        }
    )
    @action(detail=True, methods=['post'], url_path='end')
    def end(self, request, pk=None):
        """Manually end lottery."""
        lottery = self.get_object()
        
        if lottery.status == 'drawn':
            return Response(
                {'detail': 'Lottery already has a winner'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        lottery.status = 'ended'
        lottery.save()
        
        return Response({
            'detail': 'Lottery ended successfully',
            'lottery': LotterySerializer(lottery).data
        }, status=status.HTTP_200_OK)


# ============================================
# ADMIN/MANAGER ENDPOINTS - POINTS MANAGEMENT
# ============================================

@extend_schema(
    tags=['Admin'],
    operation_id='point_transactions_search',
    summary='Search point transactions',
    description='Admin search endpoint for point transactions with pagination, keyword search, and source filtering.',
    request=PointTransactionSearchRequestSerializer,
    examples=[
        OpenApiExample(
            'Search all transactions',
            value={
                'pageNumber': 1,
                'pageSize': 20,
                'keyword': '',
                'source': ''
            }
        ),
        OpenApiExample(
            'Search by source - order points',
            value={
                'pageNumber': 1,
                'pageSize': 20,
                'keyword': '',
                'source': 'order'
            }
        ),
        OpenApiExample(
            'Search by source - referral points',
            value={
                'pageNumber': 1,
                'pageSize': 20,
                'keyword': '',
                'source': 'referral'
            }
        ),
        OpenApiExample(
            'Search by keyword - phone number',
            value={
                'pageNumber': 1,
                'pageSize': 20,
                'keyword': '+989121234567',
                'source': ''
            }
        ),
        OpenApiExample(
            'Search by keyword and source',
            value={
                'pageNumber': 1,
                'pageSize': 20,
                'keyword': 'order',
                'source': 'order'
            }
        )
    ],
    responses={
        200: {
            'description': 'Point transactions list',
            'content': {
                'application/json': {
                    'example': {
                        'items': [
                            {
                                'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                                'userId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                'userPhone': '+989121234567',
                                'amount': 1,
                                'transactionType': 'earned',
                                'source': 'order',
                                'referenceId': 'abc12345-def6-7890-ghij-klmnopqrstuv',
                                'description': 'Points for order abc12345-def6-7890-ghij-klmnopqrstuv',
                                'balanceAfter': 1,
                                'createdAt': '2024-01-15T10:30:00Z'
                            },
                            {
                                'id': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                'userId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                'userPhone': '+989121234567',
                                'amount': 2,
                                'transactionType': 'earned',
                                'source': 'referral',
                                'referenceId': 'xyz98765-4321-fedc-ba09-876543210fed',
                                'description': 'Referral points for referring +989121234568',
                                'balanceAfter': 3,
                                'createdAt': '2024-01-14T09:00:00Z'
                            }
                        ],
                        'pageNumber': 1,
                        'pageSize': 20,
                        'total': 45
                    }
                }
            }
        }
    }
)
class AdminPointTransactionSearchView(APIView):
    """Admin search endpoint for point transactions."""
    permission_classes = [IsAuthenticated, IsManager]

    def post(self, request):
        """Search point transactions with pagination and filters."""
        import uuid
        
        serializer = PointTransactionSearchRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        page_number = serializer.validated_data.get('pageNumber', 1)
        page_size = serializer.validated_data.get('pageSize', 20)
        keyword = serializer.validated_data.get('keyword', '').strip()
        source_filter = serializer.validated_data.get('source', '').strip()
        
        qs = PointTransaction.objects.all().select_related('user').order_by('-created_at')
        
        # Filter by source if provided
        if source_filter:
            qs = qs.filter(source=source_filter)
        
        # Filter by keyword (search in user phone, description, reference_id)
        if keyword:
            qs = qs.filter(
                Q(user__phone_number__icontains=keyword) |
                Q(description__icontains=keyword) |
                Q(reference_id__icontains=keyword)
            )
        
        # Prefetch referral data to avoid N+1 queries
        referral_ids_raw = list(qs.filter(source='referral').exclude(reference_id='').exclude(reference_id__isnull=True).values_list('reference_id', flat=True))
        referral_ids = []
        for ref_id in referral_ids_raw:
            try:
                uuid.UUID(str(ref_id))
                referral_ids.append(ref_id)
            except (ValueError, TypeError):
                continue
        
        referral_dict = {}
        if referral_ids:
            try:
                referrals = Referral.objects.filter(id__in=referral_ids).select_related('referred')
                referral_dict = {str(ref.id): ref for ref in referrals}
            except Exception as e:
                logger.warning(f"Error prefetching referrals in admin search: {str(e)}")
                referral_dict = {}
        
        start = (page_number - 1) * page_size
        end = start + page_size
        items = list(qs[start:end])
        
        # Attach cached referrals
        for transaction in items:
            if transaction.source == 'referral' and transaction.reference_id:
                try:
                    transaction._cached_referral = referral_dict.get(str(transaction.reference_id))
                except Exception as e:
                    logger.warning(f"Error attaching cached referral for transaction {transaction.id}: {str(e)}")
        
        return Response({
            'items': PointTransactionSerializer(items, many=True).data,
            'pageNumber': page_number,
            'pageSize': page_size,
            'total': qs.count(),
        })


@extend_schema(
    tags=['Admin'],
    operation_id='points_manual_award',
    summary='Manually award points to user',
    description='Admin endpoint to manually award points to a user. Creates a point transaction with source="manual".',
    request={
        'application/json': {
            'type': 'object',
            'properties': {
                'userId': {'type': 'string', 'format': 'uuid', 'description': 'User UUID'},
                'amount': {'type': 'integer', 'description': 'Points to award (must be positive)'},
                'description': {'type': 'string', 'description': 'Reason for awarding points (optional)'}
            },
            'required': ['userId', 'amount']
        }
    },
    examples=[
        OpenApiExample(
            'Award 100 points - promotion bonus',
            value={
                'userId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                'amount': 100,
                'description': 'Special promotion bonus'
            }
        ),
        OpenApiExample(
            'Award 50 points - customer service',
            value={
                'userId': '46e818ce-0518-4c64-8438-27bc7163a706',
                'amount': 50,
                'description': 'Compensation for order delay'
            }
        ),
        OpenApiExample(
            'Award points without description',
            value={
                'userId': 'abc12345-def6-7890-ghij-klmnopqrstuv',
                'amount': 200
            }
        )
    ],
    responses={
        200: {
            'description': 'Points awarded successfully',
            'content': {
                'application/json': {
                    'examples': {
                        'example1': {
                            'summary': 'Points awarded',
                            'value': {
                                'new_balance': 150,
                                'points_awarded': 100
                            }
                        },
                        'example2': {
                            'summary': 'Points added to existing balance',
                            'value': {
                                'new_balance': 350,
                                'points_awarded': 200
                            }
                        }
                    }
                }
            }
        },
        400: {
            'description': 'Bad request',
            'content': {
                'application/json': {
                    'examples': {
                        'example1': {
                            'summary': 'Missing required fields',
                            'value': {
                                'detail': 'userId and amount are required'
                            }
                        },
                        'example2': {
                            'summary': 'Invalid amount',
                            'value': {
                                'detail': 'Amount must be positive'
                            }
                        }
                    }
                }
            }
        },
        404: {
            'description': 'User not found',
            'content': {
                'application/json': {
                    'example': {
                        'detail': 'User not found'
                    }
                }
            }
        }
    }
)
class AdminManualAwardPointsView(APIView):
    """Admin endpoint to manually award points."""
    permission_classes = [IsAuthenticated, IsManager]

    def post(self, request):
        """Award points to user."""
        from django.contrib.auth import get_user_model
        User = get_user_model()
        
        user_id = request.data.get('userId')
        amount = request.data.get('amount')
        description = request.data.get('description', 'Manual award by admin')
        
        if not user_id or not amount:
            return Response(
                {'detail': 'userId and amount are required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if amount <= 0:
            return Response(
                {'detail': 'Amount must be positive'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            user = User.objects.get(id=user_id)
        except User.DoesNotExist:
            return Response(
                {'detail': 'User not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        user_points, _ = UserPoints.objects.get_or_create(user=user)
        new_balance = user_points.add_points(
            amount=amount,
            source='manual',
            description=description
        )
        
        return Response({
            'new_balance': new_balance,
            'points_awarded': amount
        }, status=status.HTTP_200_OK)


@extend_schema(
    tags=['Admin'],
    operation_id='points_drivers_list',
    summary='List all drivers with points balance',
    description='Admin endpoint to list all drivers with their current points balance. Shows all drivers even if they have 0 points.',
    request={
        'application/json': {
            'type': 'object',
            'properties': {
                'pageNumber': {'type': 'integer', 'description': 'Page number (default: 1)'},
                'pageSize': {'type': 'integer', 'description': 'Page size (default: 20)'},
                'keyword': {'type': 'string', 'description': 'Search keyword (phone, name)'}
            }
        }
    },
    examples=[
        OpenApiExample(
            'List all drivers',
            value={
                'pageNumber': 1,
                'pageSize': 20,
                'keyword': ''
            }
        ),
        OpenApiExample(
            'Search by phone number',
            value={
                'pageNumber': 1,
                'pageSize': 20,
                'keyword': '+989121234567'
            }
        )
    ],
    responses={
        200: {
            'description': 'List of drivers with points',
            'content': {
                'application/json': {
                    'example': {
                        'items': [
                            {
                                'userId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                'userPhone': '+989121234567',
                                'userName': 'John Doe',
                                'points': 150,
                                'lifetimeEarned': 200,
                                'lifetimeSpent': 50
                            },
                            {
                                'userId': '46e818ce-0518-4c64-8438-27bc7163a706',
                                'userPhone': '+989121234568',
                                'userName': 'Jane Smith',
                                'points': 0,
                                'lifetimeEarned': 0,
                                'lifetimeSpent': 0
                            }
                        ],
                        'pageNumber': 1,
                        'pageSize': 20,
                        'total': 50
                    }
                }
            }
        }
    }
)
class AdminDriversPointsListView(APIView):
    """Admin endpoint to list all drivers with their points balance."""
    permission_classes = [IsAuthenticated, IsManager]

    def post(self, request):
        """List all drivers with points balance."""
        from django.db.models import F, Case, When, IntegerField, Value
        
        page_number = request.data.get('pageNumber', 1)
        page_size = request.data.get('pageSize', 20)
        keyword = request.data.get('keyword', '').strip()
        
        try:
            page_number = int(page_number)
        except (ValueError, TypeError):
            page_number = 1
        
        try:
            page_size = int(page_size)
        except (ValueError, TypeError):
            page_size = 20
        
        # Get all active drivers and annotate with their points balance
        qs = User.objects.filter(
            is_driver=True,
            is_active=True,
            is_active_driver=True
        ).annotate(
            points_balance=Case(
                When(user_points__isnull=False, then=F('user_points__balance')),
                default=Value(0),
                output_field=IntegerField()
            ),
            lifetime_earned=Case(
                When(user_points__isnull=False, then=F('user_points__lifetime_earned')),
                default=Value(0),
                output_field=IntegerField()
            ),
            lifetime_spent=Case(
                When(user_points__isnull=False, then=F('user_points__lifetime_spent')),
                default=Value(0),
                output_field=IntegerField()
            )
        ).select_related('user_points').distinct()
        
        # Filter by keyword if provided
        if keyword:
            qs = qs.filter(
                Q(phone_number__icontains=keyword) |
                Q(first_name__icontains=keyword) |
                Q(last_name__icontains=keyword)
            )
        
        # Order by points balance (descending)
        qs = qs.order_by('-points_balance', '-created_at')
        
        # Pagination
        total = qs.count()
        start = (page_number - 1) * page_size
        end = start + page_size
        drivers = qs[start:end]
        
        # Serialize driver data
        drivers_data = []
        for driver in drivers:
            points = getattr(driver, 'points_balance', None)
            if points is None:
                points = driver.user_points.balance if hasattr(driver, 'user_points') and driver.user_points else 0
            
            lifetime_earned = getattr(driver, 'lifetime_earned', None)
            if lifetime_earned is None:
                lifetime_earned = driver.user_points.lifetime_earned if hasattr(driver, 'user_points') and driver.user_points else 0
            
            lifetime_spent = getattr(driver, 'lifetime_spent', None)
            if lifetime_spent is None:
                lifetime_spent = driver.user_points.lifetime_spent if hasattr(driver, 'user_points') and driver.user_points else 0
            
            drivers_data.append({
                'userId': str(driver.id),
                'userPhone': driver.phone_number,
                'userName': f"{driver.first_name} {driver.last_name}".strip() or driver.phone_number,
                'points': points,
                'lifetimeEarned': lifetime_earned,
                'lifetimeSpent': lifetime_spent
            })
        
        return Response({
            'items': drivers_data,
            'pageNumber': page_number,
            'pageSize': page_size,
            'total': total
        }, status=status.HTTP_200_OK)


# ============================================
# ADMIN/MANAGER ENDPOINTS - REFERRAL MANAGEMENT
# ============================================

@extend_schema(
    tags=['Admin'],
    operation_id='referrals_search',
    summary='Search referrals',
    description='Admin search endpoint for referrals with pagination, keyword search, and status filtering.',
    request=ReferralSearchRequestSerializer,
    examples=[
        OpenApiExample(
            'Search all referrals',
            value={
                'pageNumber': 1,
                'pageSize': 20,
                'keyword': '',
                'status': ''
            }
        ),
        OpenApiExample(
            'Search completed referrals',
            value={
                'pageNumber': 1,
                'pageSize': 20,
                'keyword': '',
                'status': 'completed'
            }
        ),
        OpenApiExample(
            'Search pending referrals',
            value={
                'pageNumber': 1,
                'pageSize': 20,
                'keyword': '',
                'status': 'pending'
            }
        ),
        OpenApiExample(
            'Search by phone number',
            value={
                'pageNumber': 1,
                'pageSize': 20,
                'keyword': '+989121234567',
                'status': ''
            }
        ),
        OpenApiExample(
            'Search by referral code',
            value={
                'pageNumber': 1,
                'pageSize': 20,
                'keyword': 'ABC12345',
                'status': ''
            }
        )
    ],
    responses={
        200: {
            'description': 'Referrals list',
            'content': {
                'application/json': {
                    'example': {
                        'items': [
                            {
                                'id': '46e818ce-0518-4c64-8438-27bc7163a706',
                                'referrerId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                'referrerPhone': '+989121234567',
                                'referrerName': 'John Doe',
                                'referredId': 'abc12345-def6-7890-ghij-klmnopqrstuv',
                                'referredPhone': '+989121234568',
                                'referredName': 'Jane Smith',
                                'referral_code': 'ABC12345',
                                'status': 'completed',
                                'referrerPointsAwarded': True,
                                'referredBonusAwarded': False,
                                'completedAt': '2024-01-15T10:30:00Z',
                                'createdAt': '2024-01-14T09:00:00Z'
                            },
                            {
                                'id': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                'referrerId': '0641067f-df76-416c-98cd-6f89e43d3b3f',
                                'referrerPhone': '+989121234567',
                                'referrerName': 'John Doe',
                                'referredId': 'xyz98765-4321-fedc-ba09-876543210fed',
                                'referredPhone': '+989121234569',
                                'referredName': 'Bob Wilson',
                                'referral_code': 'ABC12345',
                                'status': 'pending',
                                'referrerPointsAwarded': False,
                                'referredBonusAwarded': False,
                                'completedAt': None,
                                'createdAt': '2024-01-16T08:00:00Z'
                            }
                        ],
                        'pageNumber': 1,
                        'pageSize': 20,
                        'total': 25
                    }
                }
            }
        }
    }
)
class AdminReferralSearchView(APIView):
    """Admin search endpoint for referrals."""
    permission_classes = [IsAuthenticated, IsManager]

    def post(self, request):
        """Search referrals with pagination and filters."""
        serializer = ReferralSearchRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        page_number = serializer.validated_data.get('pageNumber', 1)
        page_size = serializer.validated_data.get('pageSize', 20)
        keyword = serializer.validated_data.get('keyword', '').strip()
        status_filter = serializer.validated_data.get('status', '').strip()
        
        qs = Referral.objects.all().select_related('referrer', 'referred').order_by('-created_at')
        
        # Filter by status if provided
        if status_filter:
            qs = qs.filter(status=status_filter)
        
        # Filter by keyword (search in phone numbers, referral code)
        if keyword:
            qs = qs.filter(
                Q(referrer__phone_number__icontains=keyword) |
                Q(referred__phone_number__icontains=keyword) |
                Q(referral_code__icontains=keyword)
            )
        
        start = (page_number - 1) * page_size
        end = start + page_size
        items = qs[start:end]
        
        return Response({
            'items': ReferralSerializer(items, many=True).data,
            'pageNumber': page_number,
            'pageSize': page_size,
            'total': qs.count(),
        })

