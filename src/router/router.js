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
      path: '/prova',
      name: 'Prova',
      component: () => import('@/views/prova.vue')
    }
  ]
});

export default router;