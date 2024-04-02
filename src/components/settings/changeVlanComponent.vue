<script setup>
// ===========================
//           import
import { ref, inject } from 'vue'
import axios from 'axios'

// ===========================
//           const
const group = inject('selectedGroup')
const toast = inject('toast')

const visibleChangeVlan = ref(false)
const vlan = ref("")

// ===========================
//         functions
const getVlan = () => {
  vlan.value = ""
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/settings/getVlan", {params: {id: group.data.value.id}})
    .then((res) => {
      if(res.data.ok) {
        vlan.value = res.data.vlan
      }else {
        toast.toast('error', 'Error!', 'Error getting the group Vlan.')
      }
    })
}

const saveVlan = () => {
  axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/settings/saveVlan", {groupId: group.data.value.id, vlan: vlan.value})
    .then((res) => {
      if(res.data) {
        toast.toast('success', 'Saved!', 'Vlan saved successfully.')
        visibleChangeVlan.value = false
      } else {
        toast.toast('error', 'Error!', 'Error getting the group Vlan.')
      }
    })
}

</script>

<template>
  <div class="ml-6 flex justify-content-between align-items-center mt-4">
    <div class="flex align-items-center">
      <i class="pi pi-sitemap" style="font-size: 2rem"></i>
      <span class="ml-2">Change VLAN</span>
    </div>
    <Button @click="visibleChangeVlan=true; getVlan();" label="Change" class="color-light-blue-2 text-blue-500 border-blue-600  w-2" />
    <!-- DIALOG VLAN -->
    <Dialog v-model:visible="visibleChangeVlan" modal @keyup.esc="visibleChangeVlan = false"  :closable="false" :style="{ width: '30rem' }" 
      :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
      <!-- HEADER DIALOG VLAN -->
      <template #header>
        <div class="flex align-items-center">
          <i class="pi pi-sitemap" style="font-size: 1.5rem"></i>
          <b class="text-2xl ml-2">Change VLAN</b>
        </div>
      </template>
      <!-- CONTENT DIALOG VLAN -->
      <div class="color-1 shadow-3 border-round-xl p-2">
        <!-- GROUP NAME & STRATING AMOUNT -->
        <span class="col-12">
          <label class="" for="chatId">VLAN</label>
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