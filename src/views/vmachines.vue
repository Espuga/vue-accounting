<script setup>
// =============================
//           Import
import { ref, onMounted, inject } from "vue";
import { useToast } from "primevue/usetoast";
import axios from 'axios';
import IndexedDBService from './../services/IndexedDBService'

// =============================
//            Const

const toast = useToast();

const teacher = ref(false)
const group = inject('selectedGroup')
const groups = inject('groups');

// SELECTORS
const sprints = ref()
const sprint = ref()
const startDate = ref()
const endDate = ref()
const priceCpu = ref()
const priceDisk = ref()

// Datatable
const dataTable = ref()
const sumCpu = ref()
const sumDisk = ref()


const groupsData = ref()

// =============================
//          Functions

const getSelectors = async () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + "/vmachines/getSelectors")
    .then((res) => {
      if(res.data.ok){
        priceCpu.value = res.data.priceCpu
        priceDisk.value = res.data.priceDisk
        sprints.value = res.data.sprints
        // Selecionar sprint actual
        let date = new Date()
        res.data.sprints.forEach((spr) => {
          /* if(spr.name == "Sprint 6") {
            sprint.value = spr
            startDate.value = spr.start
            endDate.value = spr.end
            getDataTable()
          } */
          if(date >= new Date(spr.start) && date <= new Date(spr.end)) {
            sprint.value = spr
            startDate.value = spr.start
            endDate.value = spr.end
            getDataTable()
          }
        })

        
        

      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error getting the selectors. Try it again.', life: 4000 });
      }
    })
}

const changeSprintsDates = () => {
  sprints.value.forEach((spr) => {
    if(spr.name == sprint.value.name) {
      startDate.value = spr.start
      endDate.value = spr.end
      getDataTable()
    }
  })
} 

const getDataTable = () => {
  if(teacher.value) {
    let groupsId = ""
    groups.data.value.forEach((gr) => {
      // console.log(gr.id)
      groupsId += gr.id+","
    })
    groupsId.substring(0, groupsId.length - 1)
    axios.get(import.meta.env.VITE_APP_BACKEND_IP + "/vmachines/getGroupsDataTable", {params: {groupsId: groupsId, start: startDate.value, end: endDate.value}})
      .then((res) => {
        if(res.data.ok) {
          groupsData.value = res.data.dades
        }else {
          toast.add({ severity: 'error', summary: 'Error!', detail: 'Error getting the data. Try it again.', life: 4000 });
        }
      })
  }else{
    axios.get(import.meta.env.VITE_APP_BACKEND_IP + "/vmachines/getDataTable", {params: {groupId: group.data.value.id, start: startDate.value, end: endDate.value}})
      .then((res) => {
        if(res.data.ok){
          dataTable.value = res.data.dataTable
          sumCpu.value = res.data.sumCpu
          sumDisk.value = res.data.sumDisk
        }else {
          toast.add({ severity: 'error', summary: 'Error!', detail: 'Error getting the data. Try it again.', life: 4000 });
        }
      })
  }
}

const getRights = async () => {
  let rights = await IndexedDBService.obtenerDatos(0)
  if(rights != undefined){
    if(rights.rights.includes(2, 0)) {
      teacher.value = true
      // getInitTeacher()
    } else {
      teacher.value = false
      // getDataTable()
    }
  } else {
    teacher.value = false
    // getDataTable()
  }
  getSelectors()
  
}



/* if(!teacher){
          getDataTable()
        }else{
          getInitTeacher()
        } */

const savePrices = () => {
  let obj = {priceCpu : priceCpu.value, priceDisk: priceDisk.value}
  console.log(obj)
  axios.post(import.meta.env.VITE_APP_BACKEND_IP + '/vmachines/savePrices', obj)
    .then((res) => {
      if(res.data){
        toast.add({ severity: 'success', summary: 'Saved!', detail: 'Prices have been saved successfully.', life: 4000 });
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error saving the prices.', life: 4000 });
      }
    })
}

const doInvoice = () => {
  let vlans = []
  let prCpu = []
  let prDisk = []
  groupsData.value.forEach((gr) => {
    vlans.push(gr.vlan)
    prCpu.push(gr.sumCpu)
    prDisk.push(gr.sumDisk)
  })
  axios.post(import.meta.env.VITE_APP_BACKEND_IP + "/vmachines/doInvoice", 
  {vlans: vlans, prCpu: prCpu, prDisk: prDisk, token: window.$cookies.get("auth"), data: ""+endDate.value})
    .then((res) => {
      if(res.data){
        toast.add({ severity: 'success', summary: 'Saved!', detail: 'Invoice have been saved successfully.', life: 4000 });
      }else{
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error doing the invoice.', life: 4000 });
      }
    })
}

onMounted(() => {
  document.title = "VMachines"
  getRights()
})

</script>

<template>
  <div class="grid" v-if="!teacher">
    <!-- Selectors -->
    <div class="col-12 grid color-0 border-round-xl justify-content-center gap-3 shadow-5">
      <div class="col-2 grid">
        <div class="col-12">Sprint</div>
        <!-- <MultiSelect v-model="startDate" disabled class="col-12 w-full"/> -->
        <Dropdown v-model="sprint" @change="changeSprintsDates" :options="sprints" optionLabel="name" placeholder="Select Sprint"
            class="w-full md:w-20rem" />
      </div>
      <div class="col-2 grid">
        <div class="col-12">Start Date</div>
        <InputText v-model="startDate" disabled class="col-12 w-full"/>
      </div>
      <div class="col-2 grid">
        <div class="col-12">End Date</div>
        <InputText v-model="endDate" disabled class="col-12 w-full"/>
      </div>
      <div class="col-2 grid">
        <div class="col-12">CPU Price (<b>€</b> / <b>%</b> CPU)</div>
        <InputText v-model="priceCpu" disabled class="col-12 w-full" />
      </div>
      <div class="col-2 grid">
        <div class="col-12">Disk Price (<b>€</b> / <b>GB</b>)</div>
        <InputText v-model="priceDisk" disabled class="col-12 w-full" />
      </div>
    </div>
    <!-- End selectors -->



    <div class="col-12 grid color-0 border-round-xl mt-3 shadow-5">
      <div class="col-12 card p-0">
        <DataTable :value="dataTable" paginator :rows="8" tableStyle="min-width: 10rem" size="null" class="p-datatable-header border-1 border-solid surface-border border-round">
            <Column field="vmid" header="VMID" headerClass="bg-primary-100" sortable></Column>
            <Column field="hostname" header="Hostname" headerClass="bg-primary-100"></Column>
            <Column field="cpu" header="CPU" headerClass="bg-primary-100" sortable></Column>
            <Column field="cpus" header="CPUs" headerClass="bg-primary-100" sortable></Column>
            <Column field="maxdisk" header="MaxDisk" headerClass="bg-primary-100" sortable></Column>
            <Column field="cpuPrice" header="€ CPU" headerClass="bg-primary-100" sortable></Column>
            <Column field="diskPrice" header="€ Disk" headerClass="bg-primary-100" sortable></Column>
          </DataTable>
        <div class="col-12 grid text-center">
          <div class="col-6">Price CPU: <b>{{ sumCpu }}€</b></div>
          <div class="col-6">Price Disk: <b>{{ sumDisk }}€</b></div>
        </div>
      </div>
      
    </div>




    <!-- Toast -->
    <Toast/>
  </div>


  <!-- ==== TEACHER ===== -->
  <div class="grid" v-else>
    <!-- Selectors -->
    <div class="col-12 grid color-0 border-round-xl justify-content-center align-items-center gap-3 shadow-3">
      <div class="col-2 grid">
        <div class="col-12">Sprint</div>
        <!-- <MultiSelect v-model="startDate" disabled class="col-12 w-full"/> -->
        <Dropdown v-model="sprint" @change="changeSprintsDates" :options="sprints" optionLabel="name" placeholder="Select Sprint"
            class="w-full md:w-20rem" />
      </div>
      <div class="col-2 grid">
        <div class="col-12">Start Date</div>
        <InputText v-model="startDate" disabled class="col-12 w-full"/>
      </div>
      <div class="col-2 grid">
        <div class="col-12">End Date</div>
        <InputText v-model="endDate" disabled class="col-12 w-full"/>
      </div>
      <div class="col-2 grid">
        <div class="col-12">CPU Price (<b>€</b> / <b>%</b> CPU)</div>
        <InputText v-model="priceCpu" class="col-12 w-full" />
      </div>
      <div class="col-2 grid">
        <div class="col-12">Disk Price (<b>€</b> / <b>GB</b>)</div>
        <InputText v-model="priceDisk" class="col-12 w-full" />
      </div>
      <div class="col-2 grid gap-2 align-items-center justify-content-center">
        <Button @click="savePrices" label="Save" icon="pi pi-upload" class="color-light-blue-2 text-blue-500 border-blue-400" />
        <Button @click="doInvoice" label="Invoice" icon="pi pi-send" class="color-light-blue-2 text-blue-500 border-blue-400" />
      </div>
    </div>
    <!-- End selectors -->
    

    <div class="col-12 grid bg-white border-round-xl mt-3">
      <div v-for="groupData in groupsData" class="col-6 card p-0 color-0">


        <div class="col-12 border-round-xl shadow-5">
          <DataTable :value="groupData.dataTable" paginator :rows="5" tableStyle="min-width: 10rem" class="p-datatable-header ">
            <template #header>
                <div class="flex flex-wrap align-items-center justify-content-between gap-2 p-2 bg-primary-300 border-1 border-solid surface-border border-round w-full">
                    <span class="text-xl text-900 font-bold ">VLAN {{ groupData.vlan }}</span>
                </div>
            </template>
            <Column field="vmid" header="VMID" headerClass="bg-primary-100" sortable></Column>
            <Column field="hostname" header="Hostname" headerClass="bg-primary-100"></Column>
            <Column field="cpu" header="CPU" headerClass="bg-primary-100" sortable></Column>
            <Column field="cpus" header="CPUs" headerClass="bg-primary-100" sortable></Column>
            <Column field="maxdisk" header="MaxDisk" headerClass="bg-primary-100" sortable></Column>
            <Column field="cpuPrice" header="€ CPU" headerClass="bg-primary-100" sortable></Column>
            <Column field="diskPrice" header="€ Disk" headerClass="bg-primary-100" sortable></Column>
          </DataTable>
        </div>
        <div class="col-12 grid text-center">
          <div class="col-6">Price CPU: <b>{{ groupData.sumCpu }}€</b></div>
          <div class="col-6">Price Disk: <b>{{ groupData.sumDisk }}€</b></div>
        </div>



      </div>
    </div>

    <!-- Toast -->
    <Toast/>
  </div>

</template>