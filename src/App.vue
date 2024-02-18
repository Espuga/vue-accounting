<script setup>
// =============================
//          Import
import { ref, onMounted, provide } from "vue";
import { useToast } from "primevue/usetoast";
import axios from 'axios';
import { useRouter } from 'vue-router';

import IndexedDBService from './services/IndexedDBService'
import transactionComponent from "./components/transactionComponent.vue";
import MessagesComponent from "./components/messagesComponent.vue";


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
        label: 'New Transaction',
        icon: 'pi pi-credit-card',
        command: () => {
          transactionDialog.value = true
        }
      }
    ]
  },
  {
    label: 'VMachines',
    icon: 'pi pi-desktop',
    route: '/vmachines'
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
    label: 'Settings',
    icon: 'pi pi-cog',
    route: '/accounting/settings'
  }
]);

// Loggin
const logged = ref(false)
const user = ref("")
provide('user', user); 
const loginDialog = ref(false);
const username = ref("")
const password = ref("")

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

// Create Account 
const createAccountDialog = ref(false)
const accountName = ref(null)
const accountUsername = ref(null)
const accountPassword1 = ref(null)
const accountPassword2 = ref(null)
// Create Account invalid
const invalidAccountUsername = ref(false)
const invalidAccountPassword = ref(false)

// Transaction
const transactionDialog = ref(false)
provide('transactionDialog', {
  data: transactionDialog.value,
  update()  {
    transactionDialog.value = false
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

// DELETE COOKIE
const deleteCookie = (cookieName) => {
  document.cookie = `${cookieName}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;
};

// CLOSE CREATE ACCOUNT DIALOG
const closeCreateAccountDialog = () => {
  createAccountDialog.value = false
}

// GET USER RIGHTS
const getRights = async (groupId = group.value.id) => {
  // get admin rights
  let rights = await IndexedDBService.obtenerDatos(groupId)
  if(rights != undefined){
    if(rights.rights.includes(1, 0)) {
      admin.value = true
    } else {
      admin.value = false
    }
  } else {
    admin.value = false
  } 
  // get teacher rgihts
  rights = await IndexedDBService.obtenerDatos(0)
  if(rights != undefined){
    if(rights.rights.includes(2, 0)) {
      teacher.value = true
    } else {
      teacher.value = false
    }
  } else {
    teacher.value = false
  }
}

// SEND LOGIN FUNCTION
const login = async () => {
  loading.value = true

  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/auth/login', { params : { username: username.value, password: password.value }})
    .then((res) => {
      loading.value = false
      if(res.data.ok){
        if(res.data.token != ""){
          loginDialog.value = false
          window.$cookies.set('auth', res.data.token)
          toast.add({ severity: 'success', summary: 'Correct credentials!', detail: '', life: 4000 });
          logged.value = true
          user.value = res.data.name

          // Get rights
          res.data.rights.forEach((right) => {
            IndexedDBService.agregarDato({"rights": [right.right_id], groupId: right.group_id})
          })

          // select default group
          loading.value = true
          axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/getGroups', { params: { token: window.$cookies.get("auth") } })
            .then((res) => {
              loading.value = false
              groups.value = res.data.groups
              group.value = res.data.groups[0]
              getRights(group.value.id)
            })
        }else{
          toast.add({ severity: 'error', summary: 'Incorrect credentials!', detail: 'Username or password incorrect.', life: 4000 });
        }
      } else {
        toast.add({ severity: 'error', summary: 'Incorrect credentials!', detail: 'Username or password incorrect.', life: 4000 });
      }
    })

}

// OPEN CREATE ACCOUNT DIALOG
const openCreateAccount = () => {
  loginDialog.value = false
  createAccountDialog.value = true
}

// CREATE ACCOUNT
const submitCreateAccount = () => {
  if(accountPassword1.value == accountPassword2.value){
    // If the passwords match
    if(accountPassword1.value.length < 4){
      // Invalid password, les than 4 characters
      invalidAccountPassword.value = true
      toast.add({ severity: 'error', summary: 'Invalid password!', detail: 'The password should have at least 4 characters.', life: 4000 });
    }else{
      // If valid password
      invalidAccountPassword.value = false
      loading.value = true;
      let object = {username: accountUsername.value, name: accountName.value, password: accountPassword1.value}
      axios.post(import.meta.env.VITE_APP_BACKEND_IP + '/auth/createAccount', object, {
        headers: {
          'Content-Type': 'application/json'
        }
      })
        .then((res) => {
          loading.value = false
          if(res.data.token != ""){
            user.value = res.data.user;
            window.$cookies.set('auth', res.data.token)
            toast.add({ severity: 'success', summary: 'User created successfully!', detail: '', life: 4000 });
            logged.value = true
            createAccountDialog.value = false
            invalidAccountUsername.value = false
          }else{
            if(res.data.msg) {
              invalidAccountUsername.value = true
              toast.add({ severity: 'error', summary: 'Error creating new user!', detail: res.data.msg, life: 4000 });
            }else {
              toast.add({ severity: 'error', summary: 'Error creating new user!', detail: 'Error creating the new user, try it again.', life: 4000 });
            }
          }
        })
    }
  }else{
    // If the passwords doesn't match
    invalidAccountPassword.value = true
    toast.add({ severity: 'warn', summary: 'Passwords do not match!', detail: 'Put the same password.', life: 4000 });
  }
}

// Log out
const openLogOut = async () => {
  deleteCookie('auth')
  await IndexedDBService.deleteDatabase()
  window.location.href = '/';
}


// ON MOUNTED
onMounted(() => {
  // deleteCookie('auth')
  document.title = "Accounting"
  if(window.$cookies.isKey("auth")) {
    // If there is the cookie
    loading.value = true
    logged.value = true
    axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/auth/getUsername', { params: { token: window.$cookies.get("auth") } })
      .then((res) => {
        loading.value = false
        user.value = res.data
      })
    axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/getGroups', { params: { token: window.$cookies.get("auth") } })
      .then((res) => {
        groups.value = res.data.groups
        group.value = res.data.groups[0]
        getRights(group.value.id)
      })
  }else{
    // There isn't the cookie, log in
    loginDialog.value = true
  }
})

</script>

<template>
  <div id="app">

    <!-- MENU -->
    <div class="card">
      <Menubar :model="menuItems" class="shadow-7">
        <template #item="{ item, props, hasSubmenu }">
          <router-link v-if="item.route" v-slot="{ href, navigate }" :to="item.route" custom>
            <a :href="href" v-bind="props.action" @click="navigate">
              <span :class="item.icon" style="font-size: 1.5rem"/>
              <span class="ml-2">{{ item.label }}</span>
            </a>
          </router-link>
          <a v-else :href="item.url" :target="item.target" v-bind="props.action">
            <span :class="item.icon" style="font-size: 1.4rem" />
            <span class="ml-2">{{ item.label }}</span>
            <span v-if="hasSubmenu" class="pi pi-fw pi-angle-down ml-2" />
          </a>
        </template>
        <template #end>
          <Button v-if="logged == false" icon="pi pi-user" label="Login" @click="loginDialog = true" />
          <div v-else class="flex gap-5">

            <div class="grid justify-content-between align-items-center">
              <Dropdown @change="getRights()" v-model="group" :options="groups" optionLabel="name" placeholder="Select a Group" class="w-full " />
            </div>

            <div class="grid align-items-center mr-4">
              <i class="pi pi-user mr-2" style="font-size: 1.2rem"></i>
              <p><b>{{ user }}</b></p>
            </div>
          </div>
        </template>
      </Menubar>
    </div>
    <!-- LOGIN DIALOG -->
    <div class="card flex justify-content-center">
      <Dialog
          v-model:visible="loginDialog"
          modal
          :pt="{
              mask: {
                  style: 'backdrop-filter: blur(2px)'
              }
          }"
      >
        <template #container="{ closeCallback }">
          <div class="flex flex-column px-8 py-5 gap-4" style="border-radius: 12px; background-image: radial-gradient(circle at left top, var(--primary-400), var(--primary-700))">
            <div class="inline-flex flex-column gap-2">
              <label for="username" class="text-primary-50 font-semibold">Username</label>
              <InputText v-model="username" id="username" class="bg-white-alpha-20 border-none p-3 text-primary-50"></InputText>
            </div>
            <div class="inline-flex flex-column gap-2">
              <label for="password" class="text-primary-50 font-semibold">Password</label>
              <InputText v-model="password" @keyup.enter="login()" id="password" class="bg-white-alpha-20 border-none p-3 text-primary-50" type="password"></InputText>
            </div>
            <div class="flex w-full justify-content-end m-0">
              <a href="#" @click.prevent="openCreateAccount" class="no-underline"><p class="m-0 text-50 underline">Create Account</p></a>
            </div>
            <div class="flex align-items-center gap-2">
              <Button label="Log-In" @click="login()" text class="p-3 w-full text-primary-50 border-1 border-white-alpha-30 hover:bg-white-alpha-10"></Button>
              <Button label="Cancel" @click="closeCallback" text class="p-3 w-full text-primary-50 border-1 border-white-alpha-30 hover:bg-white-alpha-10"></Button>
            </div>
          </div>
        </template>
      </Dialog>
    </div>
    
    <!-- CREATE ACCOUNT DIALOG -->
    <Dialog v-model:visible="createAccountDialog" modal :closable="false" :style="{ width: '25rem' }" 
      :breakpoints="{ '1199px': '75vw', '575px': '90vw' }">
      <!-- HEADER -->
      <template #header>
        <div class="flex align-items-center">
          <i class="pi pi-user" style="font-size: 1.5rem"></i>
          <b class="text-2xl ml-2">Create Account</b>
        </div>
      </template>
      <!-- MAIN CONTENT -->
      <div class="mt-4 grid justify-content-center">
        <span class="col-12 flex justify-content-center w-full">
          <div class="p-float-label">
            <InputText v-model="accountName" />
            <label class="pl-2 flex align-items-center" for="user"><i class="pi pi-user mr-1" style="font-size: 1rem"></i>Name</label>
          </div>
        </span>
        <span class="col-12 flex justify-content-center w-full mt-3">
          <div class="p-float-label">
            <InputText v-model="accountUsername" :class="{'p-invalid': invalidAccountUsername}" />
            <label class="pl-2 flex align-items-center" for="username"><i class="pi pi-at mr-1" style="font-size: 1rem"></i>Username</label>
          </div>
        </span>
        <span class="col-12 flex justify-content-center w-full mt-3">
          <div class="p-float-label">
            <Password v-model="accountPassword1" toggleMask :class="{'p-invalid': invalidAccountPassword}" />
            <label class="pl-2 flex align-items-center" for="password1"><i class="pi pi-lock mr-1" style="font-size: 1rem"></i>Password</label>
          </div>
        </span>
        <span class="col-12 flex justify-content-center w-full mt-3">
          <div class="p-float-label">
            <Password v-model="accountPassword2" toggleMask :feedback="false" :class="{'p-invalid': invalidAccountPassword}" />
            <label class="pl-2 flex align-items-center" for="password2"><i class="pi pi-lock mr-1" style="font-size: 1rem"></i>Repeat the Password</label>
          </div>
        </span>
      </div>
      <!-- FOOTER -->
      <template #footer>
        <div class="flex justify-content-center">
          <Button label="Cancel" icon="pi pi-times" @click="closeCreateAccountDialog" class="surface-300 border-400 text-black-alpha-90"/>
          <Button label="Submit" icon="pi pi-send" @click="submitCreateAccount" class="bg-green-500 border-green-600"/>
        </div>
      </template>
    </Dialog>

    <!-- DIALOG TRANSACTION -->
    <transactionComponent v-if="transactionDialog"></transactionComponent>

    <MessagesComponent v-if="messageDialog"></MessagesComponent>

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
    background: rgb(131,191,246);
    background: radial-gradient(circle, rgba(131,191,246,1) 0%, rgba(24,141,240,1) 35%, rgba(24,141,240,1) 100%);
  }
</style>