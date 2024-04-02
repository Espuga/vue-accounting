<script setup>
import { ref, onMounted, inject } from 'vue'
import axios from 'axios'
import { useToast } from "primevue/usetoast";
import IndexedDBService from './../services/IndexedDBService'

const toast = useToast();
const teacher = ref(false);
const group = inject('selectedGroup')

// Teacher to Authorize
const atuhorizeData = ref()

// To Accept
const acceptData = ref()

// Teacher Accept 
const accpetTransaction = (groupId, id) => {
  axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/authorize/accpetTransaction", {groupId: groupId, id: id})
    .then((res) => {
      if(res.data) {
        toast.add({ severity: 'success', summary: 'Authorized!', detail: '', life: 4000 });
        getInit()
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error authorizing the transaction.', life: 4000 });
      }
    })
}
// Teacher Drop
const dropTransaction = (groupId, id) => {
  axios.delete(import.meta.env.VITE_APP_BACKEND_IP+"/authorize/dropTransaction/"+groupId+"/"+id)
    .then((res) => {
      if(res.data) {
        toast.add({ severity: 'success', summary: 'Unauthorized!', detail: '', life: 4000 });
        getInit()
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error unauthorizing the transaction.', life: 4000 });
      }
    })
}
// Init teacher
const getInit = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/authorize/getToAuthorize")
    .then((res) => {
      if(res.data.ok) {
        atuhorizeData.value = res.data.data
        // console.log(res.data.data)
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error loading the transactions.', life: 4000 });
      }
    })
}

const accpetTransaction2 = (id) => {
  axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/authorize/accpetTheTransaction", {groupId: ""+group.data.value.id, id: ""+id})
    .then((res) => {
      if(res.data) {
        toast.add({ severity: 'success', summary: 'Accepted!', detail: '', life: 4000 });
        getInit()
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error accpeting the transaction.', life: 4000 });
      }
    })
}

const getInit2 = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/authorize/getToAccept", {params: {groupId: group.data.value.id}})
    .then((res) => {
      if(res.data.ok){
        acceptData.value = res.data.data
        getInit2()
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error loading the transactions.', life: 4000 });
      }
    })
}

const getRights = async () => {
  let rights = await IndexedDBService.obtenerDatos(0)
  if(rights != undefined){
    if(rights.rights.includes(2, 0)) {
      teacher.value = true
      getInit()
      getInit2()
      // getInitTeacher()
    } else {
      teacher.value = false
      getInit2()
      // getDataTable()
    }
  } else {
    teacher.value = false
    getInit2()
    // getDataTable()
  }

  
}

onMounted(() => {
  getRights()
})

</script>

<template>
   <div class="flex flex-column" >
    <div class="grid">
      <!-- INICI TRANSACTIONS TO AUTHORIZE -->
      <div v-if="teacher" class="col-12">
        <Panel header="Header" ref="cardGridFi" :collapsed="false" :pt="{
            header: { class: 'color-1 border-round-top-xl shadow-5' },
            content: { class: 'color-0 border-round-bottom-3xl shadow-5' }
          }">
          <template #header>
            <div class="flex align-items-center">
              <i class="pi pi-check-circle" style="font-size: 20px" />
              <span class="text-lg ml-2"> Transactions to Authorize </span>
            </div>
          </template>
          <!-- CONTENT -->
          <DataTable :value="atuhorizeData" stripedRows paginator :rows="15" 
          tableStyle="min-width: 20rem" class="p-datatable-sm" removableSort > 

            <template #empty>
              <i class="pi pi-ban" style="font-size: 20px" />
              There aren't transactions to authorize
            </template>

            <Column field="id" header="Id" style="width: 5%" class="text-900" ></Column>
            <Column field="title" header="Title" style="width: 20%" class="text-900" ></Column>
            <Column field="description" header="Description" style="width: 30%" class="text-900" ></Column>
            <Column field="amount" header="Amount" style="width: 10%" class="text-900" ></Column>
            <Column field="group" header="Group" style="width: 10%" class="text-900" ></Column>
            <Column field="user" header="User" style="width: 10%" class="text-900" ></Column>
            <Column field="data" header="Data" style="width: 10%" class="text-900" ></Column>
            
            <Column style="width: 2.5%" bodyStyle="text-align:center">
              <template #body="{ data }">
                <a href="#" @click="accpetTransaction(data.groupId, data.id)" v-tooltip.top="'Authorize'">
                  <i class="pi pi-check text-green-500" style="font-size: 20px" />
                </a>
              </template>
            </Column>
            <Column style="width: 2.5%" bodyStyle="text-align:center">
              <template #body="{ data }">
                <a href="#" @click="dropTransaction(data.groupId, data.id)" v-tooltip.top="'Unauthorize'">
                  <i class="pi pi-times text-red-500" style="font-size: 20px" />
                </a>
              </template>
            </Column>
          </DataTable>

        </Panel>
      </div><!-- FI TRANSACTIONS TO AUTHORIZE -->

      <!-- INICI TRANSACTIONS TO ACCEPT -->
      <div class="col-12">
        <Panel header="Header" ref="cardGridFi" :collapsed="false" :pt="{
            header: { class: 'color-1 border-round-top-xl shadow-5' },
            content: { class: 'color-0 border-round-bottom-3xl shadow-5' }
          }">
          <template #header>
            <div class="flex align-items-center">
              <i class="pi pi-check-circle" style="font-size: 20px" />
              <span class="text-lg ml-2"> Transactions to Accept </span>
            </div>
          </template>
          <!-- CONTENT -->
          <DataTable :value="acceptData" stripedRows paginator :rows="15" 
          tableStyle="min-width: 20rem" class="p-datatable-sm" removableSort > 

            <template #empty>
              <i class="pi pi-ban" style="font-size: 20px" />
              There aren't transactions to accept
            </template>

            <Column field="id" header="Id" style="width: 5%" class="text-900" ></Column>
            <Column field="title" header="Title" style="width: 20%" class="text-900" ></Column>
            <Column field="description" header="Description" style="width: 30%" class="text-900" ></Column>
            <Column field="amount" header="Amount" style="width: 10%" class="text-900" ></Column>
            <Column field="group" header="Group" style="width: 10%" class="text-900" ></Column>
            <Column field="user" header="User" style="width: 10%" class="text-900" ></Column>
            <Column field="data" header="Data" style="width: 10%" class="text-900" ></Column>
            
            <Column style="width: 5%" bodyStyle="text-align:center">
              <template #body="{ data }">
                <a href="#" @click="accpetTransaction2(data.id)" v-tooltip.top="'Collect'">
                  <i class="pi pi-check text-green-500" style="font-size: 20px" />
                </a>
              </template>
            </Column>
          </DataTable>

        </Panel>
      </div><!-- FI TRANSACTIONS TO ACCEPT -->


    </div>


    <!-- TOAST -->
    <Toast />
  </div>
</template>