<script setup>
import { ref, inject } from 'vue'
import axios from 'axios'

import IndexedDBService from './../../services/IndexedDBService'

const toast = inject('toast')
const loading = inject('loading')
const groups = inject('groups')

// NEW GROUP DIALOG
const visible = ref(false)
const groupName = ref("")
const startAmount = ref(null)
const vlan = ref("")
  
// New group invalid
const submited = ref(false)

const users = ref("")
const groupNom = ref("")

const open = () => {
  visible.value = true
  groupName.value = ""
  groupNom.value = ""
  startAmount.value = null
  vlan.value = ""
  submited.value = false
}

// CREATE NEW GROUP
const createGroup = () => {
  submited.value = true
  if(!groupName.value.length < 4 && !vlan.value.length == 0 && startAmount.value!=null && !groupNom.value.length <= 1) {
    let newGroupData = { 
      token: window.$cookies.get("auth"), 
      name: groupName.value, 
      amount: startAmount.value,  
      users: users.value,
      vlan: vlan.value,
      nom: groupNom.value
    }
    loading.load(true)
    axios.post(import.meta.env.VITE_APP_BACKEND_IP + '/settings/createGroup', newGroupData )
      .then((res) => {
        if(res.data.ok){
          // Refrescar groups
          users.value = ""
          toast.toast('success', 'Created Correclty!', 'Group Created Correctly.')
          visible.value = false
          // Rigths
          res.data.rights.forEach((right) => {
            IndexedDBService.agregarDato({"rights": [right.right_id], groupId: right.group_id})
          })
          groups.updateGroups()
        }else{
          toast.toast('error', 'Error!', 'Error creating the group.')
        }
        loading.load(false)
      })
  } else {
    toast.toast('warn', 'Fill all gaps!', '')
  }
}

</script>

<template>
  <div class="ml-6 flex justify-content-between align-items-center mt-4">
    <div class="flex align-items-center">
      <i class="pi pi-plus-circle" style="font-size: 2rem"></i>
      <span class="ml-2">New group</span>
    </div>
    <Button @click="open" label="Create" class="color-light-blue-2 text-blue-500 border-blue-600 w-2" />
    <!-- DIALOG NEW GROUP -->
    <Dialog v-model:visible="visible" @keyup.esc="visible=false" modal :closable="false" :style="{ width: '50rem' }" 
      :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
      <!-- HEADER DIALOG NEW GROUP -->
      <template #header>
        <div class="flex align-items-center">
          <i class="pi pi-plus-circle" style="font-size: 1.5rem"></i>
          <b class="text-2xl ml-2">New Group</b>
        </div>
      </template>
      <!-- CONTENT DIALOG NEW GROUP -->
      <div class="p-4 pt-5 color-1 shadow-3 border-round-xl">
        <!-- GROUP NAME & STRATING AMOUNT -->
        <div class="card flex">
          <span class="col-7">
            <label class="pl-2" for="groupNom">Beautiful Group Name </label><label class="text-red-500">*</label>
            <IconField iconPosition="right" class="w-full mt-1">
              <i class="pi pi-comment"></i>
              <InputText v-model="groupNom" class="w-full mt-1" @keyup.enter="createGroup()" :class="{'p-invalid color-light-red': groupNom.length<4 && submited}" autofocus />
            </IconField>
          </span>
          <span class="col-5">
            <label class="pl-2 " for="startAmount">Starting Amount </label><label class="text-red-500">*</label>
            <IconField iconPosition="right" class="w-full mt-1">
              <i class="pi pi-euro"></i>
              <InputNumber v-model="startAmount" @keyup.enter="createGroup()" class="w-full mt-1" :minFractionDigits="0" :maxFractionDigits="2" 
                :class="{'p-invalid color-light-red': startAmount==null && submited}" />
            </IconField>
          </span>
        </div>
        <div class="card flex mt-3">
          <span class="col-7">
            <label class="pl-2" for="groupName">Group Name </label><label class="text-red-500">*</label>
            <IconField iconPosition="right" class="w-full mt-1">
              <i class="pi pi-database"></i>
              <InputText v-model="groupName" @keyup.enter="createGroup()" class="w-full mt-1" :class="{'p-invalid color-light-red': groupName.length<4 && submited}" />
            </IconField>
          </span>
          <span class="col-5">
            <label class="pl-2" for="groupName">Vlan </label><label class="text-red-500">*</label>
            <IconField iconPosition="right" class="w-full mt-1">
              <i class="pi pi-sitemap"></i>
              <InputText v-model="vlan" @keyup.enter="createGroup()" class="w-full mt-1" :class="{'p-invalid color-light-red': vlan.length==0 && submited}" />
            </IconField>
          </span>
        </div>
        <div class="card flex mt-2">
          <span class="col-12 ">
            <label class="pl-2 pt-2" for="users">Users</label>
            <IconField iconPosition="right" class="w-full mt-1">
              <i class="pi pi-users"></i>
              <Textarea autoResize rows="1" cols="30" @keyup.enter="createGroup()" v-model="users" id="users" placeholder="marc, lluc..." class="w-full mt-1" />
            </IconField>
          </span>
        </div>
      </div>
      <!-- FOOTER DIALOG NEW GROUP -->
      <template #footer>
        <div class="flex justify-content-center w-full gap-3">
          <Button label="Cancel" icon="pi pi-times" @click="visible = false" class="opacity-80 surface-200 border-400 color-1 text-black-alpha-90"/>
          <Button label="Submit" icon="pi pi-save" @click="createGroup()" class="color-light-green text-green-500 border-green-600"/>
        </div>
      </template>
    </Dialog>
  </div>
</template>