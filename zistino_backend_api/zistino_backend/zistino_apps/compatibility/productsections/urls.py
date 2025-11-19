"""
URL patterns for ProductSections compatibility layer.
Provides all 10 endpoints matching Flutter app expectations.
"""
from django.urls import path, re_path
from . import views

urlpatterns = [
    # Search endpoint (MUST come BEFORE router to avoid conflicts)
    path('search', views.ProductSectionsViewSet.as_view({'post': 'search'}), name='productsections-search'),
    
    # Custom endpoints (MUST come BEFORE router to avoid conflicts)
    path('dapper', views.ProductSectionsDapperView.as_view(), name='productsections-dapper'),
    path('all', views.ProductSectionsAllView.as_view(), name='productsections-all'),
    path('by-group-name', views.ProductSectionsByGroupNameView.as_view(), name='productsections-by-group-name'),
    path('by-page', views.ProductSectionsByPageView.as_view(), name='productsections-by-page'),
    
    # Explicit routes for list/create (ensures POST /productsections works)
    path('', views.ProductSectionsViewSet.as_view({'get': 'list', 'post': 'create'}), name='productsections-list-create'),
    
    # Detail routes (GET/PUT/DELETE /productsections/{id})
    path('<int:pk>', views.ProductSectionsViewSet.as_view({
        'get': 'retrieve',
        'put': 'update',
        'patch': 'partial_update',
        'delete': 'destroy'
    }), name='productsections-detail'),
]

