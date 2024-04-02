<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const messagesDataTable = ref()

onMounted(() => {
  document.title = "Messages"
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/telegram/getMessages")
    .then((res) => {
      if(res.data.ok){
        messagesDataTable.value = res.data.messages
      }else{
        console.error("Error")
      }
    })
})


</script>

<template>
  <div class="card ml-2 mr-2 pl-8 pr-8 pt-4">
    <Card class="ml-4 mr-4 pl-8 pr-8 pt-4 pb-6 shadow-5 border-round-2xl color-0">
      <!-- SETTINGS TITLE -->
      <template #title>
        <div class="flex align-items-center mt-2">
          <i class="pi pi-telegram mr-2" style="font-size: 3rem"></i>
          Telegram Messages 
        </div>
      </template>
      <!-- SETTINGS CONTENT -->
      <template #content>
        
        <DataTable :value="messagesDataTable" stripedRows paginator :rows="20" 
        exportFilename="messages" ref="transactionDataExport" 
        tableStyle="min-width: 20rem" class="p-datatable-sm shadow-4 border-round-xl" 
        removableSort :pt="{
            root: { class: 'border-round-xl' },
            header: { class: 'border-round-top-xl' },
            footer: { class: 'border-round-bottom-2xl' }
        }"> 
          <template #empty>
            <i class="pi pi-ban" style="font-size: 20px" />
            There are no messages
          </template>


          <Column field="id" header="Id" style="width: 7%" class="text-900" ></Column>
          <Column field="message" header="Message" style="width: 60%" class="text-900"></Column>
          <Column field="name" header="Name" style="width: 20%" class="text-900" ></Column>
          <Column field="date" header="Date" style="width: 13%" class="text-900"></Column>
        </DataTable>

      </template>
    </Card>
  </div>
</template>