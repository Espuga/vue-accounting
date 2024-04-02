import { createRouter, createWebHistory } from "vue-router";

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      name: 'Home',
      component: () => import('@/views/home.vue'),
      meta: { title: 'Accounting' }
    },
    {
      path: '/accounting/dashboard',
      name: 'Dashboard',
      component: () => import('@/views/dashboard.vue'),
      meta: { title: 'Accounting - Dashboard' }
    },
    {
      path: '/accounting/settings',
      name: 'Settings',
      component: () => import('@/views/settings.vue'),
      meta: { title: 'Accounting - Settings' }
    },
    {
      path: '/vmachines',
      name: 'VMachines',
      component: () => import('@/views/vmachines.vue'),
      meta: { title: 'VMachines' }
    },
    {
      path: '/messages',
      name: 'Messages',
      component: () => import('@/views/messages.vue')
    },
    {
      path: '/accounting/authorize',
      name: 'Authorize',
      component: () => import('@/views/authorize.vue')
    },
    {
      path: '/projects',
      name: 'Projects',
      component: () => import('@/views/projects.vue')
    },
    {
      path: '/accounting/fixedCosts',
      name: 'Fixed Costs',
      component: () => import('@/views/fixedCosts.vue')
    },
    {
      path: '/devices',
      name: 'Devices',
      component: () => import('@/views/devices.vue')
    },
    {
      path: '/profile',
      name: 'Profile',
      component: () => import('@/views/profile.vue')
    },
    {
      path: '/prova',
      name: 'Prova',
      component: () => import('@/views/prova.vue')
    },
    {
      path: '/:pathMatch(.*)',
      redirect: '/'
    }
  ]
});

export default router;