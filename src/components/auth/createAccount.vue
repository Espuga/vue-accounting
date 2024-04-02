<script setup>
import { ref, inject, defineEmits } from 'vue'
import axios from 'axios'


const emit = defineEmits(['create-account-success'])

const toast = inject('toast')
const loading = inject('loading')

// Create Account 
const createAccountDialog = ref(true)
const accountName = ref(null)
const accountUsername = ref(null)
const accountImg = ref(null)
const accountPassword1 = ref(null)
const accountPassword2 = ref(null)
const accountClass = ref({ name: "1st Course", code: 1})
const optionAccountClass = ref([
  { name: "1st Course", code: 1},
  { name: "2nd Course", code: 1}
])
// Create Account invalid
const invalidAccountUsername = ref(false)
const invalidAccountPassword = ref(false)

// CREATE ACCOUNT
const submitCreateAccount = () => {
  if(accountPassword1.value == accountPassword2.value){
    // If the passwords match
    if(accountPassword1.value.length < 4){
      // Invalid password, les than 4 characters
      invalidAccountPassword.value = true
      toast.toast('error', 'Invalid password!', 'The password should have at least 4 characters.')
    }else{
      // If valid password
      invalidAccountPassword.value = false
      loading.load(true)
      let object = {username: accountUsername.value, name: accountName.value, password: accountPassword1.value, course: accountClass.value.code, img: accountImg.value}
      axios.post(import.meta.env.VITE_APP_BACKEND_IP + '/auth/createAccount', object, {
        headers: {
          'Content-Type': 'application/json'
        }
      })
        .then((res) => {
          loading.load(false)
          if(res.data.token != ""){
            window.$cookies.set('auth', res.data.token)
            toast.toast('success', 'User created successfully!', '')
            
            createAccountDialog.value = false
            invalidAccountUsername.value = false
            emit('create-account-success');
          }else{
            if(res.data.msg) {
              invalidAccountUsername.value = true
              toast.toast('error', 'Error creating new user!', res.data.msg)
            }else {
              toast.toast('error', 'Error creating new user!', 'Error creating the new user, try it again.')
            }
          }
        })
    }
  }else{
    // If the passwords doesn't match
    invalidAccountPassword.value = true
    toast.toast('warn', 'Passwords do not match!', 'Put the same password.')
  }
}

// CLOSE CREATE ACCOUNT DIALOG
const closeCreateAccountDialog = () => {
  createAccountDialog.value = false
}

</script>

<template>
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
          <InputText v-model="accountName" class="w-full"/>
          <label class="pl-2 flex align-items-center" for="user"><i class="pi pi-user mr-1" style="font-size: 1rem"></i>Name</label>
        </div>
      </span>
      <span class="col-12 flex justify-content-center w-full">
        <div class="">
          <Dropdown v-model="accountClass" :options="optionAccountClass" optionLabel="name" placeholder="Select the Course" class="w-full md:w-14rem" />
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
          <InputText v-model="accountImg" />
          <label class="pl-2 flex align-items-center" for="img"><i class="pi pi-globe mr-1" style="font-size: 1rem"></i>Profile img URL</label>
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
      <div class="flex justify-content-center w-full gap-3">
        <Button label="Cancel" icon="pi pi-times" @click="closeCreateAccountDialog" class="surface-300 border-400 text-black-alpha-90"/>
        <Button label="Submit" icon="pi pi-send" @click="submitCreateAccount" class="bg-green-500 border-green-600"/>
      </div>
    </template>
  </Dialog>
</template>