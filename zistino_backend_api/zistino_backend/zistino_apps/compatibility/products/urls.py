"""
URL patterns for Products compatibility layer.
Provides all ~34 endpoints matching Flutter app expectations.
"""
from django.urls import path, include, re_path
from ..router import NoTrailingSlashRouter
from . import views

router = NoTrailingSlashRouter()
router.register(r'', views.ProductsViewSet, basename='products')

urlpatterns = [
    # IMPORTANT: Custom endpoints must come BEFORE router URLs to avoid conflicts
    # Router will try to match everything as {id} UUID, so specific paths must come first
    
    # Admin search endpoint (MUST come BEFORE router to avoid conflicts)
    path('search', views.ProductsViewSet.as_view({'post': 'search'}), name='products-search'),
    
    # Custom endpoints - Image 1
    path('edit/<str:id>', views.ProductsEditView.as_view(), name='products-edit'),
    path('dapper/<str:id>', views.ProductsDapperView.as_view(), name='products-dapper'),
    path('all', views.ProductsAllView.as_view(), name='products-all'),
    
    # Client endpoints (must come before router to avoid UUID validation conflicts)
    path('client', views.ProductsClientView.as_view(), name='products-client-create'),
    path('client/by-name', views.ProductsClientByNameView.as_view(), name='products-client-by-name'),
    path('client/top5', views.ProductsClientTop5View.as_view(), name='products-client-top5'),
    path('client/search', views.ProductsClientSearchView.as_view(), name='products-client-search'),
    path('client/searchext', views.ProductsClientSearchExtView.as_view(), name='products-client-searchext'),
    path('client/searchwithtags', views.ProductsClientSearchWithTagsView.as_view(), name='products-client-searchwithtags'),
    path('client/bytagname', views.ProductsClientByTagNameView.as_view(), name='products-client-bytagname'),
    path('client/by-categoryid/top5/<str:id>', views.ProductsClientByCategoryIdTop5View.as_view(), name='products-client-by-categoryid-top5'),
    path('client/by-categorytype/top5/<str:id>', views.ProductsClientByCategoryTypeTop5View.as_view(), name='products-client-by-categorytype-top5'),
    path('client/by-categoryid/<str:id>', views.ProductsClientByCategoryIdView.as_view(), name='products-client-by-categoryid'),
    path('client/by-categorytype/<str:id>', views.ProductsClientByCategoryTypeView.as_view(), name='products-client-by-categorytype'),
    path('client/withrelatedbycategory/<str:id>', views.ProductsClientWithRelatedByCategoryView.as_view(), name='products-client-withrelatedbycategory'),
    path('client/prefilter/<str:id>', views.ProductsClientPrefilterView.as_view(), name='products-client-prefilter'),
    path('client/prefiltermaxmin/<str:Name>', views.ProductsClientPrefilterMaxMinView.as_view(), name='products-client-prefiltermaxmin'),
    path('client/filter/<str:type>/<str:name>', views.ProductsClientFilterByTypeView.as_view(), name='products-client-filter-by-type'),
    path('client/filter/<str:name>', views.ProductsClientFilterView.as_view(), name='products-client-filter'),
    path('client/<str:id>', views.ProductsClientRetrieveView.as_view(), name='products-client-retrieve'),
    
    # Custom endpoints - Image 2
    path('sold/<str:productId>', views.ProductsSoldView.as_view(), name='products-sold'),
    
    # Product codes endpoints (must come before detail route to avoid UUID conflicts)
    re_path(r'^(?P<id>[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/codes$', views.ProductsViewSet.as_view({'get': 'list_codes'}), name='products-codes-list'),
    re_path(r'^(?P<id>[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})/codes/bulk-import$', views.ProductsViewSet.as_view({'post': 'bulk_import_codes'}), name='products-codes-bulk-import'),
    
    # Admin endpoints
    path('admin/searchext', views.ProductsAdminSearchExtView.as_view(), name='products-admin-searchext'),
    
    # Explicit routes for list/create (ensures POST /products works)
    # Router should handle this, but adding explicit route to guarantee it works
    path('', views.ProductsViewSet.as_view({'get': 'list', 'post': 'create'}), name='products-list-create'),
    
    # Detail routes (GET/PUT/DELETE /products/{id}) - using UUID regex
    # Use re_path to match UUID format
    re_path(r'^(?P<id>[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})$', views.ProductsViewSet.as_view({
        'get': 'retrieve',
        'put': 'update',
        'patch': 'partial_update',
        'delete': 'destroy'
    }), name='products-detail'),
]

