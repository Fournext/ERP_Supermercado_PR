import { Routes } from '@angular/router';
import { authGuard } from './business/Protection _outes/auth.guard';
import { InicioComponent } from './cliente/inicio/inicio.component';

export const routes: Routes = [
  {
    path: '', redirectTo: 'ecommerce', pathMatch: 'full'
  },
  {
    path: 'login',
    loadComponent: () => import('./business/login/login.component')
  },
  {
    path: 'login-cliente',
    loadComponent: () => import('./cliente/login-cliente/login-cliente.component')
  },
  {
    path: 'register-cliente',
    loadComponent: () => import('./cliente/register-cliente/register-cliente.component')
  },
  {
    path: 'ecommerce',
    component: InicioComponent,
    children: [
      {
        path: 'carrito',
        loadComponent: () => import('./cliente/carrito/carrito.component').then(m => m.CarritoComponent)
      },
      {
        path: 'cliente',
        loadComponent: () => import('./cliente/cliente/cliente.component').then(m => m.ClienteComponent)
      }, {
        path: 'factura',
        loadComponent: () => import('./cliente/factura-cliente/factura-cliente.component').then(m => m.FacturaClienteComponent)
      }
    ]
  },

  //parte de del dashboard
  {
    path: '',
    canActivate: [authGuard],
    loadComponent: () => import('./shared/components/layout/layout.component'),
    children: [
      {
        path: 'dashboard',
        loadComponent: () => import('./business/dashboard/dashboard.component')
      },
      {
        path: 'inventory',
        loadComponent: () => import('./business/inventory/inventory.component')
      },
      {
        path: 'products',
        loadComponent: () => import('./business/products/products.component')
      },
      {
        path: 'profile',
        loadComponent: () => import('./business/profile/profile.component')
      },
      {
        path: 'user',
        loadComponent: () => import('./business/user/user.component')
      },
      {
        path: 'marcas',
        loadComponent: () => import('./business/marcas/marcas.component')
      },
      {
        path: 'categorias',
        loadComponent: () => import('./business/categoria/categoria.component')
      },
      {
        path: 'bitacora',
        loadComponent: () => import('./business/bitacora/bitacora.component')
      },
      {
        path: 'roles',
        loadComponent: () => import('./business/rol-y-permisos/rol-y-permisos.component')
      },
      {
        path: 'turno',
        loadComponent: () => import('./business/turno/turno.component')
      },
      {
        path: 'almacen',
        loadComponent: () => import('./business/almacen/almacen.component')
      },
      {
        path: 'sector',
        loadComponent: () => import('./business/sector/sector.component')
      },
      {
        path: 'repisa',
        loadComponent: () => import('./business/repisa/repisa.component')
      },
      {
        path: 'boleta_salida',
        loadComponent: () => import('./business/boleta-salida/boleta-salida.component')
      },
      {
        path: 'proveedor',
        loadComponent: () => import('./business/proveedores/proveedores.component')
      },
      {
        path: 'compras',
        loadComponent: () => import('./business/compras-page/compras-page.component')
      },
      {
        path: 'boleta_entrada',
        loadComponent: () => import('./business/boleta-entrada/boleta-entrada.component')
      },
      {
        path: 'valoracion',
        loadComponent: () => import('./business/valoracion/valoracion.component')
      },
      {
        path: 'backup',
        loadComponent: () => import('./business/backup/backup.component')
      },
      {
        path: '',
        redirectTo: 'dashboard',
        pathMatch: 'full'
      }
    ]
  },
  //Redireccionar al Dashboard si direccionan a cualquier ruta
  {
    path: '**',
    redirectTo: 'dashboard'
  }
];
