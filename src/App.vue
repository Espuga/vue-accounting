<script setup>
// =============================
//          Import
import { ref, onMounted, provide, reactive } from "vue";
import { useToast } from "primevue/usetoast";
import axios from 'axios';
import { useRouter } from 'vue-router';

import IndexedDBService from './services/IndexedDBService'
import transactionComponent from "./components/transactionComponent.vue";
import MessagesComponent from "./components/messagesComponent.vue";
import projectComponent from "./components/projectComponent.vue";
import recordComponent from "./components/recordComponent.vue";
import login from "./components/auth/login.vue";


// =============================
//          Const

// General cosnt
const router = useRouter()
const toast = useToast();
const menuItems = ref([
  {
    label: '',
    icon: 'pi pi-bars',
    items: [
      {
        label: 'Profile',
        icon: 'pi pi-user',
        route: '/profile'
      },
      {
        label: 'Messages',
        icon: 'pi pi-telegram',
        items: [
        {
            label: 'Messages',
            icon: 'pi pi-database',
            route: '/messages'
          },
          {
            label: 'Send Message',
            icon: 'pi pi-send',
            command: () => {
              messageDialog.value = true;
            }
          },
        ]
      },
      {
        label: 'Log Out',
        icon: 'pi pi-sign-out',
        command: () => {
          openLogOut()
        }
      }
    ]
  },
  {
    label: 'Home',
    icon: 'pi pi-home',
    route: '/'
  },
  {
    label: 'Accounting',
    icon: 'pi pi-chart-line',
    items: [
      {
        label: 'Dashboard',
        icon: 'pi pi-chart-bar',
        route: '/accounting/dashboard'
      },
      {
        label: 'Authorize',
        icon: 'pi pi-check-circle',
        route: '/accounting/authorize'
      },
      {
        label: 'New Transaction',
        icon: 'pi pi-credit-card',
        command: () => {
          transactionDialog.value = true
        }
      },
      {
        label: 'Fixed Costs',
        icon: 'pi pi-list',
        route: '/accounting/fixedCosts'
      },
    ]
  },
  {
    label: 'Projects',
    icon: 'pi pi-database',
    items: [
      {
        label: 'Projects',
        icon: 'pi pi-book',
        route: '/projects'
      },
      {
        label: 'New Project',
        icon: 'pi pi-plus',
        command: () => {
          projectDialog.value = true
        }
      },
      {
        label: 'Record Hours',
        icon: 'pi pi-play',
        command: () => {
          recordDialog.value = true
        }
      }
    ]
  },
  {
    label: 'VMachines',
    icon: 'pi pi-server',
    // route: '/vmachines'
    items: [
      {
        label: 'Proxmox',
        icon: 'pi pi-desktop',
        route: '/vmachines'
      },
      {
        label: 'Devices',
        icon: 'pi pi-wifi',
        route: '/devices'
      }
    ]
  },
  {
    label: 'Settings',
    icon: 'pi pi-cog',
    route: '/accounting/settings'
  }
]);

// Loggin
const logged = ref(false)
const user = ref("")
provide('user', user);
const img = ref()

// Groups
const group = ref({name: "", id: 0})
provide('selectedGroup', { data: group }); 
const groups = ref([]) 
provide('groups', {
  data: groups,
  updateGroups(){
    // Update groups where new user is created
    axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/getGroups', { params: { token: window.$cookies.get("auth") } })
      .then((res) => {
        groups.value = res.data.groups
        group.value = res.data.groups[0]
        getRights(group.value.id)
      })
  }
});

// User Rights
const admin = ref(false)
provide('isAdmin', {
  data: admin,
  updateAdmin(groupId) {
    getRights(groupId)
  },
}); 
const teacher = ref(false)
provide('teacher', teacher.value)



// Transaction
const transactionDialog = ref(false)
provide('transactionDialog', {
  data: transactionDialog.value,
  update()  {
    transactionDialog.value = false
  }
})

// Project
const projectDialog = ref(false)
provide('projectDialog', {
  data: projectDialog.value,
  update()  {
    projectDialog.value = false
  }
})

// Recording
const recordDialog = ref(false)
provide('recordDialog', {
  data: recordDialog.value,
  update()  {
    recordDialog.value = false
  }
})

// loading
const loading = ref(false)
provide('loading', {
  data: loading.value,
  load(val) {
    loading.value = val
  },
})
// toast
provide('toast', {
  data: null,
  toast(severity, summary, detail) {
    toast.add({ severity: severity, summary: summary, detail: detail, life: 4000 });
  }
})

// Send Message
const messageDialog = ref(false)
provide('messageDialog', {
  data: messageDialog.value,
  update()  {
    messageDialog.value = false
  }
})

// =============================
//          Functions

const loginDone = (userData) => {
  logged.value = userData.logged
  admin.value = userData.admin
  teacher.value = userData.teacher
  group.value = userData.group
  groups.value = userData.groups
  img.value = userData.img
  user.value = userData.user
}

// DELETE COOKIE
const deleteCookie = (cookieName) => {
  document.cookie = `${cookieName}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;
};




// Log out
const openLogOut = async () => {
  deleteCookie('auth')
  await IndexedDBService.deleteDatabase()
  window.location.href = router.fullPath;
  // window.location.href = '/';
}

</script>

<template>
  <div id="app">

    <!-- MENU -->
    <div class="card">
      <Menubar :model="menuItems" :pt="{
        root: { class: 'color-1 shadow-3' }
      }">
        <template #item="{ item, props, hasSubmenu }">
          <router-link v-if="item.route" v-slot="{ href, navigate }" :to="item.route" custom>
            <a :href="href" v-bind="props.action" @click="navigate">
              <span :class="item.icon" style="font-size: 1.5rem"/>
              <span class="ml-2">{{ item.label }}</span>
              <Badge v-if="item.badge" class="ml-2 color-light-blue-4" :value="item.badge" />
            </a>
          </router-link>
          <a v-else :href="item.url" :target="item.target" v-bind="props.action">
            <span :class="item.icon" style="font-size: 1.4rem" />
            <span class="ml-2">{{ item.label }}</span>
            <Badge v-if="item.badge" class="ml-2 color-light-blue-4" :value="item.badge" />
            <span v-if="hasSubmenu" class="pi pi-fw pi-angle-down ml-2" />
          </a>
        </template>
        <template #end>
          <Button v-if="logged == false" icon="pi pi-user" label="Login" @click="loginDialog = true" />
          <div v-else class="flex gap-5">
            <div class="grid justify-content-between align-items-center">
              <Dropdown @change="getRights(); toast.add({ severity: 'info', summary: 'Group changed!', detail: '', life: 750 });" 
              v-model="group" :options="groups" optionLabel="nom" placeholder="Select a Group" class="w-full " />
            </div>
            <div class="grid align-items-center mr-4">
              <img v-if="img != ''" class="border-circle mr-2" style="width: 2rem" :src="img" />
              <i v-else class="pi pi-user mr-2" style="font-size: 1.2rem"></i>
              <p><b>{{ user }}</b></p>
            </div>
          </div>
        </template>
      </Menubar>
    </div>

    <!-- LOGIN DIALOG -->
    <login v-if="!logged" @login-success="loginDone"></login>

    <!-- DIALOG TRANSACTION -->
    <transactionComponent v-if="transactionDialog"></transactionComponent>

    <MessagesComponent v-if="messageDialog"></MessagesComponent>

    <projectComponent v-if="projectDialog"></projectComponent>

    <recordComponent v-if="recordDialog"></recordComponent>

    <!-- ROUTER VIEW -->
    <RouterView v-if="logged" class="m-4"></RouterView>

    <!-- TOAST -->
    <Toast />

    <!-- LOADING PROGRESS SPINNER -->
    <Dialog v-model:visible="loading" header="Loading..." modal :closable="false">
      <ProgressSpinner />
    </Dialog>

  </div><!-- END APP -->
</template>



<style>
  body {
    background: rgb(255,255,255);
    /* background: rgb(131,191,246); */
    /* background: radial-gradient(circle, rgba(131,191,246,1) 0%, rgba(24,141,240,1) 35%, rgba(24,141,240,1) 100%); */
  }
</style>