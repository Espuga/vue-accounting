<script setup>
import { inject } from 'vue'
import axios from 'axios'
import { useConfirm } from "primevue/useconfirm";


// Library 
const confirm = useConfirm();

const group = inject('selectedGroup')
const groups = inject('groups');
const toast = inject('toast')
const loading = inject('loading')

// DLETE GROUP CONFIRMATION
const openDeleteGroup = () => {
  if(group.data.value == null){
    toast.toast('warn', 'No group selected!', 'Please, select a group to manage it.')
  }else {
    confirm.require({
      group: 'headless',
      message: 'Are you sure you want to delete the group?',
      header: 'Confirmation',
      accept: () => {
        loading.load(true);
        axios.delete(import.meta.env.VITE_APP_BACKEND_IP + '/settings/deleteGroup', {params: {groupId: group.data.value.id}})
          .then((res) => {
            if(res.data){
              // Refrescar groups
              toast.toast('success', 'Confirmed!', 'Group has been deleted.')
              groups.updateGroups()
            }else {
              toast.toast('error', 'Error!', 'An error occurred while deleting the group. Try it again.')
            }
            loading.load(false)
          })
      },
      reject: () => {
        toast.toast('warn', 'Cancelled!', 'Group hasn\'t been deleted.')
      }
    });
  }
}
</script>

<template>
  <div class="ml-6 mt-4">
    <div class="flex justify-content-between align-items-center">
      <div class="flex align-items-center">
        <i class="pi pi-trash" style="font-size: 2rem"></i>
        <span class="ml-2">Delete Group</span>
      </div>
      <Button @click="openDeleteGroup()" label="Delete" class="color-light-blue-2 text-blue-500 border-blue-600 w-2" />

    </div>  

    
  </div>
</template>