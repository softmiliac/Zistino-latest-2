"""
Categories compatibility URL routes for Flutter apps.
All 13 endpoints from Swagger: https://recycle.metadatads.com/swagger/index.html#/Categories

Flutter expects: /api/v1/categories/{endpoint}
All endpoints are tagged with 'Categories' to appear grouped in Swagger UI.

Endpoints:
1. GET /api/v1/categories/{id} - Retrieves a category by its ID
2. PUT /api/v1/categories/{id} - Updates an existing category by its ID
3. DELETE /api/v1/categories/{id} - Deletes a category by its ID
4. GET /api/v1/categories/dapper - Get categories (dapper context)
5. POST /api/v1/categories/search - Search categories using available Filters
6. POST /api/v1/categories - Creates a new category
7. GET /api/v1/categories/by-type-nolocal/{type} - Get categories by type (no local)
8. GET /api/v1/categories/by-type/{type} - Get categories by type
9. GET /api/v1/categories/client/by-type/{type} - Get client categories by type
10. GET /api/v1/categories/client/by-type-sort/{type} - Get client categories by type (sorted)
11. GET /api/v1/categories/client/by-type-sort-desc/{type} - Get client categories by type (sorted desc)
12. GET /api/v1/categories/client/parents/{Id} - Get parent categories for client
13. GET /api/v1/categories/client/by-type-count/{type} - Get count of client categories by type
"""
from django.urls import path, re_path
from . import views

# ============================================================================
# CUSTOM ENDPOINTS - MUST come BEFORE detail route to avoid conflicts
# ============================================================================

urlpatterns = [
    # ========================================================================
    # SPECIFIC ENDPOINTS - MUST come FIRST to avoid conflicts with detail route
    # ========================================================================
    
    # Search endpoint
    path('search', views.CategoryViewSet.as_view({'post': 'search'}), name='categories-search'),
    
    # GET /api/v1/categories/dapper
    path('dapper', views.CategoryViewSet.as_view({'get': 'dapper'}), name='categories-dapper'),
    
    # GET /api/v1/categories/by-type-nolocal/{type}
    path('by-type-nolocal/<str:type>', views.CategoriesByTypeNoLocalView.as_view(), name='categories-by-type-nolocal'),
    
    # GET /api/v1/categories/by-type/{type} - MUST be before detail route
    path('by-type/<str:type>', views.CategoriesByTypeView.as_view(), name='categories-by-type'),
    
    # GET /api/v1/categories/client/by-type/{type}
    path('client/by-type/<str:type>', views.CategoriesClientByTypeView.as_view(), name='categories-client-by-type'),
    
    # GET /api/v1/categories/client/by-type-sort/{type}
    path('client/by-type-sort/<str:type>', views.CategoriesClientByTypeSortView.as_view(), name='categories-client-by-type-sort'),
    
    # GET /api/v1/categories/client/by-type-sort-desc/{type}
    path('client/by-type-sort-desc/<str:type>', views.CategoriesClientByTypeSortDescView.as_view(), name='categories-client-by-type-sort-desc'),
    
    # GET /api/v1/categories/client/parents/{Id}
    path('client/parents/<str:Id>', views.CategoriesClientParentsView.as_view(), name='categories-client-parents'),
    
    # GET /api/v1/categories/client/by-type-count/{type}
    path('client/by-type-count/<str:type>', views.CategoriesClientByTypeCountView.as_view(), name='categories-client-by-type-count'),
    
    # ========================================================================
    # STANDARD REST ENDPOINTS
    # IMPORTANT: Empty path must come AFTER all specific paths but BEFORE detail route
    # ========================================================================
    
    # GET /api/v1/categories (list) and POST /api/v1/categories (create)
    # Combined into single route to handle both methods
    # Using re_path to handle both with and without trailing slash (APPEND_SLASH = False)
    re_path(r'^$', views.CategoryViewSet.as_view({'get': 'list', 'post': 'create'}), name='category-list-create'),
    
    # ========================================================================
    # DETAIL ROUTE - MUST come LAST to avoid conflicts with specific routes above
    # ========================================================================
    
    # GET/PUT/PATCH/DELETE /api/v1/categories/{id}
    path('<str:id>', views.CategoryViewSet.as_view({
        'get': 'retrieve',
        'put': 'update',
        'patch': 'partial_update',
        'delete': 'destroy'
    }), name='category-detail'),
]

