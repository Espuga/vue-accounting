<script setup>
import { ref, onMounted, inject } from 'vue'
import axios from 'axios'
import IndexedDBService from '../services/IndexedDBService';
import { useToast } from "primevue/usetoast";

const toast = useToast();
const teacher = ref(false)

const fixedData = ref()
const editingRows = ref([]);
const name = ref(null)
const amount = ref(null)

const saveFixedCost = () => {
  if(name.value != null && amount.value != null) {
    axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/fixedCosts/saveFixedCost", { name: name.value, amount: amount.value })
      .then((res) => {
        if(res.data) {
          toast.add({ severity: 'success', summary: 'Saved!', detail: 'Fixed Cost saved successfully.', life: 3000})
          name.value = null
          amount.value = null
          getFixed()
        } else {
          toast.add({ severity: 'error', summary: 'Error!', detail: 'Error while trying to save the Fixed Cost.', life: 3000})
        }
      })
  }
}

const onRowEditSave = (event) => {
  let { newData, index } = event
  let obj = {id: newData.id, name: newData.name, amount: newData.amount}
  axios.post(import.meta.env.VITE_APP_BACKEND_IP + "/fixedCosts/updateFixedCost", obj)
    .then((res) => {
      if(res.data) {
        toast.add({ severity: 'success', summary: 'Saved!', detail: 'Fixed Cost saved successfully.', life: 4000 });
        getFixed()
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error while saving the Fixed Cost.', life: 4000 });
      }
    })
};

const deleteCost = (id) => {
  axios.delete(import.meta.env.VITE_APP_BACKEND_IP+"/fixedCosts/deleteFixedCost/"+id)
    .then((res) => {
      if(res.data) {
        toast.add({ severity: 'success', summary: 'Deleted!', detail: 'Fixed Cost deleted successfully.', life: 4000 });
        getFixed()
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error while deletting the Fixed Cost.', life: 4000 });
      }
    })
}

const getRights = async () => {
  // get teacher rgihts
  let rights = await IndexedDBService.obtenerDatos(0)
  if(rights != undefined){
    if(rights.rights.includes(2, 0)) {
      teacher.value = true
    }
  }
}

const getFixed = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/fixedCosts/getFixedCosts")
    .then((res) => {
      if(res.data.ok) {
        fixedData.value = res.data.fixedCosts
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error while trying to get the Fixed Costs.', life: 3000})
      }
    })
}

onMounted(() => {
  getRights()
  getFixed()
})

</script>

<template>
  <div class="flex flex-column" >
    <div class="grid align-items-center justify-content-center">
      <!-- SELECTORS -->
      <div v-if="teacher" class="col-8 mt-4 color-0 shadow-3 border-round-xl">
        <div class="col-12 ml-1 grid border-round-xl justify-content-center gap-3">
          <div class="col-5 grid">
            <div class="col-12">Name</div>
            <InputText v-model="name" class="col-12 w-full"/>
          </div>
          <div class="col-3 grid">
            <div class="col-12">Amount</div>
            <InputNumber v-model="amount" :minFractionDigits="0" :maxFractionDigits="2" mode="currency" currency="EUR" locale="de-DE" 
              class="w-full" />
          </div>
          <div class="col-2 grid align-items-end justify-content-start ml-4">
            <Button @click="saveFixedCost" label="Save" icon="pi pi-save" class="color-light-blue-2 text-blue-500 border-blue-400" />
          </div>
        </div>
      </div>
      <!-- ENDS SELECTORS -->
      <div class="col-8 mt-4">
        <Panel header="Header" ref="cardGridFi" :collapsed="false" :pt="{
            header: { class: 'color-1 border-round-top-xl shadow-5' },
            content: { class: 'color-0 border-round-bottom-3xl shadow-5' }
          }">
          <template #header>
            <div class="flex align-items-center">
              <i class="pi pi-users" style="font-size: 20px" />
              <span class="text-lg ml-2">Fixed Costs</span>
            </div>
          </template>
          <!-- DATATABLE -->
          <DataTable :value="fixedData" stripedRows paginator :rows="15" 
          tableStyle="min-width: 20rem" class="p-datatable-sm mx-5 shadow-5 border-round-3xl" removableSort 
          v-model:editingRows="editingRows" editMode="row" @row-edit-save="onRowEditSave"> 
            <template #empty>
              <i class="pi pi-ban" style="font-size: 20px" />
              There are no fixed costs!
            </template>
            <Column field="name" header="Name" style="width: 50%" >
              <template #body="{ data, field }">
                {{ data[field] }}
              </template>
            </Column>
            <Column field="amount" header="Amount" style="width: 20%" >
              <template #body="{ data, field }">
                {{ data[field] }} €
              </template>
              <template #editor="{ data, field }">
                <InputNumber v-model="data[field]" :minFractionDigits="0" :maxFractionDigits="2" mode="currency" currency="EUR" locale="de-DE" />
              </template>
            </Column>
            <Column v-if="teacher" :rowEditor="true" style="width: 20%" bodyStyle="text-align:end"></Column>
            <Column v-if="teacher" style="width: 5%" bodyStyle="text-align:center">
              <template #body="{ data }">
                <a href="#" @click="deleteCost(data.id)" v-tooltip.top="'Delete'">
                  <i class="pi pi-trash text-500" style="font-size: 20px" />
                </a>
              </template>
            </Column>
          </DataTable>
        </Panel>
      </div>





     </div>
  </div>
  <Toast/>
</template>