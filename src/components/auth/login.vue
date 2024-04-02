<script setup>
import { ref, inject, onMounted, defineEmits } from 'vue'
import axios from 'axios'
import IndexedDBService from './../../services/IndexedDBService'
import createAccount from './createAccount.vue';

const loading = inject('loading')
const toast = inject('toast')

const emit = defineEmits(['login-success']);

const logged = ref(false)
const user = ref("")
const group = ref({name: "", id: 0})
const admin = ref(false)
const groups = ref([]) 
const teacher = ref(false)
// Loggin
const img = ref("") 
const loginDialog = ref(false);
const username = ref("")
const password = ref("")

const createAccountDialog = ref(false)

const getTeacher = async () => {
  let rights = await IndexedDBService.obtenerDatos(0)
  if(rights != undefined){
    if(rights.rights.includes(2, 0)) {
      return true
    } else {
      return false
    }
  } else {
    return false
  }
}
// GET USER RIGHTS
const getRights = async (groupId = group.value.id) => {
  // get admin rights
  let rights = await IndexedDBService.obtenerDatos(groupId)
  if(rights != undefined){
    if(rights.rights.includes(1, 0)) {
      return true
    } else {
      return false
    }
  } else {
    return false
  } 
  
}

// SEND LOGIN FUNCTION
const login = async () => {
  loading.load(true)
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/auth/login', { params : { username: username.value, password: password.value }})
    .then((res) => {
      loading.load(false)
      if(res.data.ok){
        if(res.data.token != ""){
          loginDialog.value = false
          window.$cookies.set('auth', res.data.token)
          toast.toast('success', 'Correct credentials!', '')
          // Get rights
          res.data.rights.forEach((right) => {
            IndexedDBService.agregarDato({"rights": [right.right_id], groupId: right.group_id})
          })
          user.value = res.data.name
          img.value = res.data.img
          getTeacher()
            .then((answer) => {
              teacher.value = answer
            })
          
          // select default group
          loading.load(true)
          axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/getGroups', { params: { token: window.$cookies.get("auth") } })
            .then((res) => {
              loading.load(false)
              groups.value = res.data.groups
              group.value = res.data.groups[0]
              getRights(group.value.id)
                .then((answer) => {
                  admin.value = answer
                  const userData = {
                    logged: true,
                    user: user.value,
                    img: img.value,
                    teacher: teacher.value,
                    group: group.value,
                    groups: groups.value,
                    admin: admin.value
                  };
                  emit('login-success', userData);
                })
            })
          
        }else{
          toast.toast('error', 'Incorrect credentials!', 'Username or password incorrect.')
        }
      } else {
        toast.toast('error', 'Incorrect credentials!', 'Username or password incorrect.')
      }
    })
}

// OPEN CREATE ACCOUNT DIALOG
const openCreateAccount = () => {
  loginDialog.value = false
  createAccountDialog.value = true
}

// DELETE COOKIE
const deleteCookie = (cookieName) => {
  document.cookie = `${cookieName}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;
};

const autoLogin = () => {
  getTeacher()
      .then((answer) => {
        teacher.value = answer
      })
    // If there is the cookie
    loading.load(true)
    axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/auth/getInfo', { params: { token: window.$cookies.get("auth") } })
      .then((res) => {
        loading.load(false)
        if(res.data.ok) {
          user.value = res.data.name
          img.value = res.data.img
        } else {
          toast.toast('error', 'Error!', '')
        }
      })
    axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/getGroups', { params: { token: window.$cookies.get("auth") } })
      .then((res) => {
        // console.log(res.data.groups.length)
        if(res.data.groups.length==0){
          const userData = {
            logged: true,
            teacher: teacher.value,
            user: user.value,
            img: img.value,
            groups: groups.value,
            group: group.value,
            admin: false
          }
          emit('login-success', userData);
        }else {
          groups.value = res.data.groups
          group.value = res.data.groups[0]
          getRights(group.value.id)
            .then((answer) => {
              admin.value = answer
              const userData = {
                logged: true,
                teacher: teacher.value,
                user: user.value,
                img: img.value,
                groups: groups.value,
                group: group.value,
                admin: admin.value
              }
              emit('login-success', userData);
            })
        }
      })
}

// ON MOUNTED
onMounted(() => {
  // deleteCookie('auth')
  document.title = "Accounting"
  if(window.$cookies.isKey("auth")) {
    autoLogin()
  }else{
    // There isn't the cookie, log in
    loginDialog.value = true
  }
})

</script>

<template>
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
        <div class="border-round-2xl bg-white text-black-alpha-70">
          <div class="flex flex-column color-0 shadow-3 m-4 p-3 gap-4 border-round-2xl">
            <div class="inline-flex flex-column gap-2">
              <label for="username" class="font-semibold">Username</label>
              <InputText v-model="username" id="username" class="color-1 border-black-1 p-3 shadow-2"></InputText>
            </div>
            <div class="inline-flex flex-column gap-2">
              <label for="password" class="font-semibold">Password</label>
              <InputText v-model="password" @keyup.enter="login()" id="password" class="color-1 border-black-1 p-3 shadow-2" type="password"></InputText>
            </div>
            <div class="flex w-full justify-content-end m-0">
              <a href="#" @click.prevent="openCreateAccount" class="no-underline"><p class="m-0 text-black-alpha-70 underline">Create Account</p></a>
            </div>
            <div class="flex align-items-center gap-2">
              <Button label="Log-In" @click="login()" text class="p-3 w-full color-light-green text-green-500 border-green-600 shadow-2"></Button>
              <Button label="Cancel" @click="closeCallback" text class="p-3 w-full opacity-80 surface-200 border-400 color-1 text-black-alpha-90 shadow-2"></Button>
            </div>
          </div>
        </div>
      </template>
    </Dialog>
  </div>

  <createAccount v-if="createAccountDialog" @create-account-success="autoLogin" ></createAccount>
</template>