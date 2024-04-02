<script setup>
// ===========================
//           import
import { ref, inject, defineEmits } from 'vue'
import axios from 'axios'


// ===========================
//           const
const emit = defineEmits(['changed'])
const toast = inject('toast')

const visibleChangeVlan = ref(false)
const vlan = ref("")

// ===========================
//         functions
const getProfileImg = () => {
  vlan.value = ""
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/auth/getProfileImg", {params: {token: window.$cookies.get("auth")}})
    .then((res) => {
      if(res.data.ok) {
        vlan.value = res.data.url
      }else {
        toast.toast('error', 'Error!', 'Error getting the picture url.')
      }
    })
}

const saveVlan = () => {
  axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/auth/saveProfileImg", new URLSearchParams({ token: window.$cookies.get("auth"), url: vlan.value }))
    .then((res) => {
      if(res.data) {
        toast.toast('success', 'Saved!', '')
        visibleChangeVlan.value = false
        emit('changed')
      } else {
        toast.toast('error', 'Error!', 'Error saving the picture url.')
      }
    })
}

</script>

<template>
  <div class="flex justify-content-between align-items-center">
    <div @click="visibleChangeVlan=true; getProfileImg()" class="flex align-items-center cursor-pointer">
      <p class="underline m-0"><i class="pi pi-cog mr-1" style="font-size:1.2rem"></i>Change Profile img</p>
    </div>

    <!-- DIALOG VLAN -->
    <Dialog v-model:visible="visibleChangeVlan" modal @keyup.esc="visibleChangeVlan = false"  :closable="false" :style="{ width: '30rem' }" 
      :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
      <!-- HEADER DIALOG VLAN -->
      <template #header>
        <div class="flex align-items-center">
          <i class="pi pi-image" style="font-size: 1.5rem"></i>
          <b class="text-2xl ml-2">Change Profile img</b>
        </div>
      </template>
      <!-- CONTENT DIALOG VLAN -->
      <div class="color-1 shadow-3 border-round-xl p-2">
        <!-- GROUP NAME & STRATING AMOUNT -->
        <span class="col-12">
          <label class="" for="chatId">URL</label>
          <InputText v-model="vlan" class="w-full mt-1" autofocus  @keyup.enter="saveVlan()"/>
        </span>
      </div>
      <!-- FOOTER DIALOG VLAN -->
      <template #footer>
        <div class="flex justify-content-center w-full gap-3">
          <Button label="Cancel" icon="pi pi-times" @click="visibleChangeVlan = false" class="opacity-80 surface-200 border-400 text-black-alpha-90"/>
          <Button label="Submit" icon="pi pi-save" @click="saveVlan()" class="color-light-green text-green-500 border-green-600"/>
        </div>
      </template>
    </Dialog>
  </div>
</template>