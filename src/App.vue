<script setup>
// =============================
//          Import
import { ref, onMounted, provide } from "vue";
import { useToast } from "primevue/usetoast";
import axios from 'axios';
import { useRouter } from 'vue-router';

import IndexedDBService from './services/IndexedDBService'


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
      },
      {
        label: 'Settings',
        icon: 'pi pi-cog',
        route: '/accounting/settings'
      }
    ]
  },
  {
    label: 'VMachines',
    icon: 'pi pi-desktop',
    route: '/vmachines'
  },
]);

// Loggin
const logged = ref(false)
const user = ref("")
provide('user', user); 
const loginDialog = ref(false);
const username = ref("")
const password = ref("")
const group = ref({name: "", id: 0})
provide('selectedGroup', {
  data: group,
  updateGroup(newGroup) {
    group.value = newGroup;
    getHome()
  },
  updateChart(gr){
    getChart(gr)
  }
}); 
const groups = ref([])
// provide('groups', groups);
provide('groups', {
  data: groups,
  updateGroups(){
    axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/getGroups', { params: { token: window.$cookies.get("auth") } })
      .then((res) => {
        groups.value = res.data.groups
        group.value = res.data.groups[0]
        getRights(group.value.id)
      })
  }
});
const admin = ref(false)
provide('isAdmin', {
  data: admin,
  updateAdmin(groupId) {
    getRights(groupId)
  },
}); 

// Create Account 
const createAccountDialog = ref(false)
const accountName = ref(null)
const accountUsername = ref(null)
const accountPassword1 = ref(null)
const accountPassword2 = ref(null)
  // Create Account invalid
const invalidAccountUsername = ref(false)
const invalidAccountPassword = ref(false)

// Accounting Dashboard
const dataTable = ref([])
provide('dataTable', dataTable); 
const labelsChart = ref([])
provide('labelsChart', labelsChart); 
const dataChart = ref([])
provide('dataChart', dataChart); 
const addedData = ref([])
provide('addedData', addedData); 
const withdrawedData = ref([])
provide('withdrawedData', withdrawedData); 
const dataChart1 = ref([])
provide('dataChart1', dataChart1); 

// Accounting Money
const money = ref(0)
provide('money', money)

// Dialog
const transactionDialog = ref(false);
const dialogSelected = ref('Add Funds');
const dialogOptions = ref(['Add Funds', 'Withdraw Funds']);

// Transaction
const fundsAmount = ref()
const fundsTitle = ref("")
const fundsDescription = ref("")
const fundsChecked = ref(false)
const currentDate = new Date()
const formatDate = ref(currentDate.getFullYear()+"-"+(parseInt(currentDate.getMonth())+1)+"-"+currentDate.getDate())
const fundsDate = ref(formatDate)
const titleInvalid = ref(false)
const amountInvalid = ref(false)
const descriptionInvalid = ref(false)

// loading
const loading = ref(false)


// =============================
//          Functions

// DELETE COOKIE
const deleteCookie = (cookieName) => {
  document.cookie = `${cookieName}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;
};

// CLOSE TRANSACTION DATA DIALOG
const closeTransactionDialog = () => {
  transactionDialog.value = false;
  const currentRoute = router.currentRoute.value;
  router.push({ path: currentRoute.path });  
}

// CLOSE CREATE ACCOUNT DIALOG
const closeCreateAccountDialog = () => {
  createAccountDialog.value = false
}

// GET CHART DATA
const getChart = (gr) => {
  try {
    if(gr == 0){
      gr = group.value.id
    }
    loading.value = true
    axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/getInit', { params: { groupId: gr } })
      .then((res) => {
        loading.value = false
        if(res.data.ok){
          // DataTable
          dataTable.value = res.data.dataTable
          // Weekly Chart
          labelsChart.value = res.data.dataChart.dates
          dataChart.value = res.data.dataChart.totalData
          addedData.value = res.data.dataChart.addedData
          withdrawedData.value = res.data.dataChart.withdrawedData
          dataChart1.value = res.data.dataChart.totalData
        }
      })
  }catch {
    toast.add({ severity: 'warn', summary: 'No Groups!', detail: 'You are not in any group.', life: 4000 });
  }
}

// SUBMIT TRANSACTION DATA
const submitTransaction = () => {
  if(fundsAmount.value == 0 || fundsAmount.value == null || fundsTitle.value == "" || fundsDescription.value == ""){
    // If some field is empty, WARNING!
    toast.add({ severity: 'warn', summary: 'Warning!', detail: 'Fill all gaps.', life: 4000 });
    amountInvalid.value = fundsAmount.value == 0 || fundsAmount.value == null || fundsAmount.value == undefined ? true : false;
    titleInvalid.value = fundsTitle.value == "" ? true : false;
    descriptionInvalid.value = fundsDescription.value == "" ? true : false;
  }else{
    let date = new Date(fundsDate.value)
    let formatDate = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
    let object = {title: fundsTitle.value, description: fundsDescription.value, amount: fundsAmount.value, date: formatDate,
                  groupId: group.value.id, token: window.$cookies.get('auth')};
    if(dialogSelected.value!='Add Funds'){
      object.amount = object.amount*-1
    }
    loading.value = true
    axios.post(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/setTransaction', object)
      .then((res) => {
        loading.value = false
        if(res.data.ok){
          // Put 0 / null all fields
          fundsAmount.value = null
          fundsTitle.value = ""
          fundsDescription.value = ""
          // Success toast
          toast.add({ severity: 'success', summary: 'Transaction Correctly!', detail: 'The transaction was saved correctly.', life: 4000 });
          // Close Dialog
          transactionDialog.value = false;
          //location.reload();
          getChart(0)
        }else{
          toast.add({ severity: 'error', summary: 'Transaction Error!', detail: 'The transaction couldn\'t be completed.', life: 4000 });
        }
      })
  }
}

// RESET TRANSACTION DATE (CURRENT DATE)
const changeChecked = () => {
  if(fundsChecked.value == false){
    formatDate.value = currentDate.getFullYear()+"-"+(parseInt(currentDate.getMonth())+1)+"-"+currentDate.getDate()
  }
}

// GET USER RIGHTS
const getRights = async (groupId) => {
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
}

async function encryptPassword(password) {
  const encoder = new TextEncoder();
  const data = encoder.encode(password);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  const hashedPassword = hashArray.map(byte => byte.toString(16).padStart(2, '0')).join('');
  return hashedPassword;
}

// SEND LOGIN FUNCTION
const login = () => {
  loading.value = true
  encryptPassword(password.value)
    .then((pass) =>{
      axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/auth/login', { params : { username: username.value, password: pass }})
        .then((res) => {
          loading.value = false
          if(res.data.ok){
            if(res.data.token != ""){
              loginDialog.value = false
              window.$cookies.set('auth', res.data.token)
              toast.add({ severity: 'success', summary: 'Correct credentials!', detail: '', life: 4000 });
              
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
                  getHome()
                  getChart(0)
                })
              
              
              /* logged.value = true
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
                  getHome()
                  getChart(0)
                }) */
            }else{
              toast.add({ severity: 'error', summary: 'Incorrect credentials!', detail: 'Username or password incorrect.', life: 4000 });
            }
          } else {
            toast.add({ severity: 'error', summary: 'Incorrect credentials!', detail: 'Username or password incorrect.', life: 4000 });
          }
        })
    })
    .catch ((error) => {
      console.error(error)
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
    if(accountPassword1.value.length < 4){
      invalidAccountPassword.value = true
      toast.add({ severity: 'error', summary: 'Invalid password!', detail: 'The password should have at least 4 characters.', life: 4000 });
    }else{
      invalidAccountPassword.value = false
      loading.value = true;
      encryptPassword(accountPassword1.value)
        .then((pass) => {
          let object = {username: accountUsername.value, name: accountName.value, password: pass}
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
        })
        .catch((error) => {
          console.error(error)
        })
    }
  }else{
    invalidAccountPassword.value = true
    toast.add({ severity: 'warn', summary: 'Passwords do not match!', detail: 'Put the same password.', life: 4000 });
  }
}

const getHome = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/getHome', { params: { groupId: group.value.id } })
    .then((res) => {
      if(res.data.ok){
        money.value = res.data.amount
      }
    })
}

const openLogOut = () => {
  deleteCookie('auth')
  window.location.href = '/';
  // router.replace({ path: '/' });  
}

/* const currentRoute = router.currentRoute.value;
  router.push({ path: currentRoute.path });  */

// ON MOUNTED
onMounted(() => {
  // deleteCookie('auth')
  document.title = "Accounting"
  if(window.$cookies.isKey("auth")) {
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
        getHome()
        getChart(0)
      })
  }else{
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
          <div v-else class="grid align-items-center mr-4">
            <i class="pi pi-user mr-2" style="font-size: 1.2rem"></i>
            <p><b>{{ user }}</b></p>
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
              <InputText v-model="password" id="password" class="bg-white-alpha-20 border-none p-3 text-primary-50" type="password"></InputText>
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
    <Dialog v-model:visible="transactionDialog" modal :closable="false" :style="{ width: '50rem' }" 
      :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
      <!-- HEADER -->
      <template #header>
        <div class="flex align-items-center">
          <i class="pi pi-chart-line" style="font-size: 1.5rem"></i>
          <b class="text-2xl ml-2">Transaction</b>
        </div>
      </template>
      <!-- MAIN CONTENT -->
      <div class="card flex justify-content-center mt-1">
        <SelectButton v-model="dialogSelected" :options="dialogOptions" aria-labelledby="basic" />
      </div>

      <div class="mt-4">
        <div class="card flex">
          <span class="col-7 p-float-label">
            <InputText :class="{ 'p-invalid': titleInvalid }" v-model="fundsTitle" class="w-full" />
            <label class="pl-2" for="title">Title</label>
          </span>
          <span class="col-4 p-float-label">
            <InputNumber :class="{'p-invalid': amountInvalid}" v-model="fundsAmount" :minFractionDigits="0" :maxFractionDigits="2" mode="currency" currency="EUR" locale="de-DE" 
              class="w-full" />
            <label for="amount" 
              :class="['pl-2 flex align-items-center', dialogSelected === 'Add Funds' ? 'text-green-400' : 'text-red-400']">
              <i class="pi pi-euro mr-2" style="font-size: 1rem"></i>
              Amount
            </label>
          </span>
        </div>
        <div class="card flex ml-2 mr-5 mt-4">
          <span class="p-float-label w-full">
            <Textarea :class="{ 'p-invalid': descriptionInvalid }" v-model="fundsDescription" autoResize rows="5" cols="30" class="w-full" />
            <label for="description">Description</label>
          </span>
        </div>
        <div class="card flex ml-2 mr-5 mt-4 justify-content-right align-items-center">
          <label for="changeDate" class="flex align-items-center"><i class="pi pi-calendar" style="font-size: 1.5rem"></i>Change date</label>
          <InputSwitch v-model="fundsChecked" @change="changeChecked" class="ml-2" />
        </div>
        <div v-if="fundsChecked==true" class="card flex ml-2 mr-5 mt-2 justify-content-right">
          <Calendar v-model="fundsDate" dateFormat="yy-mm-dd" />
        </div >
      </div>
      <!-- FOOTER -->
      <template #footer>
        <div class="flex justify-content-center">
          <Button label="Cancel" icon="pi pi-times" @click="closeTransactionDialog" class="surface-300 border-400 text-black-alpha-90"/>
          <Button label="Submit" icon="pi pi-upload" @click="submitTransaction" :class="[dialogSelected=='Add Funds' ? 'bg-green-500 border-green-600' : 'bg-red-500 border-red-600']"/>
        </div>
      </template>
    </Dialog>

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