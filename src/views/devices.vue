<script setup>
// =============================
//           Import
import { ref, onMounted, inject, watch } from "vue";
import { useToast } from "primevue/usetoast";
import axios from 'axios';
import { FilterMatchMode } from 'primevue/api';
import IndexedDBService from './../services/IndexedDBService'

// =============================
//            Const

const toast = useToast();

const teacher = ref(false)
const group = inject('selectedGroup')

// Selectors
const options = ref([])

// Add device
const ip = ref(null)
const device = ref(null)
const service = ref(null)
const port = ref(null)
const username = ref(null)
const password = ref(null)
const invalidIp = ref(false)
const invalidDevice = ref(false)
const invalidService = ref(false)
const invalidPort = ref(false)
const invalidUsername = ref(false)
const invalidPassword = ref(false)

// Table
const devicesData = ref()
const editingRows = ref([]);
const filters = ref({
  ip: { value: null, matchMode: FilterMatchMode.CONTAINS },
  name: { value: null, matchMode: FilterMatchMode.CONTAINS }
});


const getRights = async () => {
  let rights = await IndexedDBService.obtenerDatos(0)
  if(rights != undefined){
    if(rights.rights.includes(2, 0)) {
      teacher.value = true
    }
  } 
  
}

const getDevices = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/devices/getDevices", { params: { groupId: group.data.value.id } })
    .then((res) => {
      if(res.data.ok) {
        devicesData.value = res.data.devices
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error while getting the Devices.', life: 3000 })
      }
    })
}

watch(() => group.data.value, getDevices)

/* const addDevice = () => {
  if(
      (ip.value==null || ip.value == "") || 
      (service.value==null || service.value=="") ||
      (username.value==null || username.value=="") || 
      (password.value==null || password.value=="")
    ){
    invalidIp.value = (ip.value==null || ip.value=="") ? true : false
    invalidService.value = (service.value==null || service.value=="") ? true : false
    invalidUsername.value = (username.value==null || username.value=="") ? true : false
    invalidPassword.value = (password.value==null || password.value=="") ? true : false
  } else {
    invalidIp.value = false
    invalidService.value = false
    invalidUsername.value = false
    invalidPassword.value = false
    axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/devices/newDevice", 
    {ip: ip.value, name: device.value, service: service.value, username: username.value, password: password.value, groupId: group.data.value.id})
      .then((res) => {
        if(res.data) {
          getDevices()
          ip.value = null
          device.value = null
          service.value = null
          username.value = null
          password.value = null
          toast.add({ severity: 'success', summary: 'Saved!', detail: 'Device saved successfully.', life: 3000 })
        }else {
          toast.add({ severity: 'error', summary: 'Error!', detail: 'Error while getting the Devices.', life: 3000 })
        }
      })
  }
} */

const onRowEditSave = (event) => {
  let { newData, index } = event
  axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/devices/updateDevice", newData)
    .then((res) => {
      if(res.data) {
        getDevices()
        toast.add({ severity: 'success', summary: 'Updated!', detail: 'Device updated successfully.', life: 3000 })
      } else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error while updatting the Devices.', life: 3000 })
      }
    })
};

const deleteService = (data, i) => {
  axios.delete(import.meta.env.VITE_APP_BACKEND_IP+"/devices/deleteCredential/"+data.id+"/"+data.services[i]+"/"+data.usernames[i]+"/"+data.passwords[i])
    .then((res) => {
      if(res.data) {
        getDevices()
        toast.add({ severity: 'success', summary: 'Updated!', detail: 'Device updated successfully.', life: 3000 })
      } else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error while updatting the Devices.', life: 3000 })
      }
    })
}

const deleteDevice = (id) => {
  axios.delete(import.meta.env.VITE_APP_BACKEND_IP+"/devices/deleteDevice/"+id)
    .then((res) => {
      if(res.data) {
        getDevices()
        toast.add({ severity: 'success', summary: 'Deleted!', detail: 'Device deleted successfully.', life: 3000 })
      } else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error while deletting the Device.', life: 3000 })
      }
    })
}

onMounted(() => {
  document.title = "VMachines"
  getRights()
  getDevices()
})

const clearContent = () => {
  ip.value = null
  device.value = null
  service.value = null
  port.value = null
  username.value = null
  password.value = null
}

const addNew = async () => {
  if(options.value.length==2){
    if(
      (ip.value==null || ip.value == "") || 
      (device.value==null || device.value=="") ||
      (service.value==null || service.value=="") ||
      (port.value==null || port.value=="") ||
      (username.value==null || username.value=="") || 
      (password.value==null || password.value=="")
    ) {
      toast.add({ severity: 'warn', summary: 'Warning!', detail: 'Fill all gaps.', life: 3000 })
      invalidIp.value = (ip.value==null || ip.value=="") ? true : false
      invalidDevice.value = (device.value==null || device.value=="") ? true : false
      invalidService.value = (service.value==null || service.value=="") ? true : false
      invalidPort.value = (port.value==null || port.value=="") ? true : false
      invalidUsername.value = (username.value==null || username.value=="") ? true : false
      invalidPassword.value = (password.value==null || password.value=="") ? true : false
    } else {
      invalidIp.value = false
      invalidDevice.value = false
      invalidService.value = false
      invalidPort.value = false
      invalidUsername.value = false
      invalidPassword.value = false

      let newDevice = {ip: ip.value, name: device.value, groupId: group.data.value.id}
      axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/devices/addDevice", newDevice)
        .then((res) => {
          if(res.data.ok) {
            // correctament
            let newService = {ip: ip.value, name: service.value, port: port.value, username: username.value, password: password.value, groupId: group.data.value.id}
            axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/devices/addService", newService)
              .then((res) => {
                if(res.data.ok) {
                  toast.add({ severity: 'success', summary: 'Saved!', detail: 'Device saved successfully.', life: 3000 })
                  clearContent()
                  getDevices()
                } else {
                  toast.add({ severity: 'error', summary: 'Error!', detail: res.data.msg, life: 4000 })
                }
              })
          } else {
            toast.add({ severity: 'error', summary: 'Error!', detail: res.data.msg, life: 4000 })
          }
        })
    }

  } else {
    if(options.value.includes('Device')) {
      if(
        (ip.value==null || ip.value == "") || 
        (device.value==null || device.value=="")
      ) {
        toast.add({ severity: 'warn', summary: 'Warning!', detail: 'Fill all gaps.', life: 3000 })
        invalidIp.value = (ip.value==null || ip.value=="") ? true : false
        invalidDevice.value = (device.value==null || device.value=="") ? true : false
      } else {
        invalidIp.value = false
        invalidDevice.value = false
        
        let newDevice = {ip: ip.value, name: device.value, groupId: group.data.value.id}
        axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/devices/addDevice", newDevice)
          .then((res) => {
            if(res.data.ok){
              toast.add({ severity: 'success', summary: 'Saved!', detail: 'Device saved successfully.', life: 3000 })
              clearContent()
              getDevices()
            } else {
              toast.add({ severity: 'error', summary: 'Error!', detail: res.data.msg, life: 4000 })
            }
          })
      }
    } else {
      if(
        (ip.value==null || ip.value == "") || 
        (service.value==null || service.value=="") ||
        (username.value==null || username.value=="") || 
        (password.value==null || password.value=="")
      ) {
        toast.add({ severity: 'warn', summary: 'Warning!', detail: 'Fill all gaps.', life: 3000 })
        invalidIp.value = (ip.value==null || ip.value=="") ? true : false
        invalidService.value = (service.value==null || service.value=="") ? true : false
        invalidUsername.value = (username.value==null || username.value=="") ? true : false
        invalidPassword.value = (password.value==null || password.value=="") ? true : false
      } else {
        invalidIp.value = false
        invalidService.value = false
        invalidUsername.value = false
        invalidPassword.value = false

        let newService = {ip: ip.value, name: service.value, port: port.value, username: username.value, password: password.value, groupId: group.data.value.id}
        axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/devices/addService", newService)
          .then((res) => {
            if(res.data.ok) {
              toast.add({ severity: 'success', summary: 'Saved!', detail: 'Service saved successfully.', life: 3000 })
              clearContent()
              getDevices()
            } else {
              toast.add({ severity: 'error', summary: 'Error!', detail: res.data.msg, life: 4000 })
            }
          })
      }
    }
  }
}

</script>

<template>
  <div class="flex flex-column justify-content-center">
    <div class="flex flex-column color-0 border-round-xl justify-content-center align-items-center gap-2 shadow-3">
      <div class="card flex flex-wrap justify-content-center gap-3 mt-3 mx-4">
        <div class="flex align-items-center">
          <Checkbox v-model="options" inputId="device" name="options" value="Device" />
          <label for="device" class="ml-2"> Device </label>
        </div>
        <div class="flex align-items-center">
          <Checkbox v-model="options" inputId="service" name="options" value="Service" />
          <label for="service" class="ml-2"> Service </label>
        </div>
        <div class="flex align-items-center">
          <i v-if="options.length!=0" class="pi pi-info-circle cursor-pointer" style="font-size: 1.3rem;" v-tooltip.bottom="'Enter to submit'"></i>
        </div>
      </div>
      <div class="card flex flex-column justify-content-center gap-3 mb-2 mx-4">
        <div v-if="options.includes('Device')" class="card flex flex-wrap justify-content-center gap-3 mx-4">
          <IconField iconPosition="left" v-tooltip.bottom="'Enter the IP'">
              <i class="pi pi-wifi"/>
              <InputText :class="{'p-invalid': invalidIp}" v-model="ip" placeholder="IP" @keyup.enter="addNew()" />
          </IconField>
          <IconField iconPosition="left" v-tooltip.bottom="'Enter the Device'">
              <i class="pi pi-desktop"/>
              <InputText :class="{'p-invalid': invalidDevice}" v-model="device" placeholder="Device Name" @keyup.enter="addNew()" />
          </IconField>
        </div>
        <Divider v-if="options.length==2" class="m-0"/>
        <div v-if="options.includes('Service')" class="card flex flex-wrap justify-content-center gap-3 mb-2 mx-4">
          <IconField v-if="!options.includes('Device')" iconPosition="left" v-tooltip.bottom="'Enter the IP'">
              <i class="pi pi-wifi"/>
              <InputText :class="{'p-invalid': invalidIp}" v-model="ip" placeholder="IP" @keyup.enter="addNew()" />
          </IconField>
          <IconField iconPosition="left" v-tooltip.bottom="'Enter the Service'">
              <i class="pi pi-globe"/>
              <InputText :class="{'p-invalid': invalidService}" v-model="service" placeholder="Service" @keyup.enter="addNew()" />
          </IconField>
          <IconField iconPosition="left" v-tooltip.bottom="'Enter the Port'">
              <i class="pi pi-sitemap"/>
              <InputText :class="{'p-invalid': invalidPort}" v-model="port" placeholder="Port" @keyup.enter="addNew()" />
          </IconField>
          <IconField iconPosition="left" v-tooltip.bottom="'Enter the Username'">
              <i class="pi pi-user"/>
              <InputText :class="{'p-invalid': invalidUsername}" v-model="username" placeholder="Username" @keyup.enter="addNew()" />
          </IconField>
          <IconField iconPosition="left" v-tooltip.bottom="'Enter the Password'">
              <i class="pi pi-lock"/>
              <Password :class="{'p-invalid': invalidPassword}" v-model="password" placeholder="Password" :feedback="false" @keyup.enter="addNew()" toggleMask/>
          </IconField>
        </div>
      </div>
    </div>
    

    <div class="grid border-round-xl justify-content-center align-items-center gap-3 mt-3">
      <div class="col-10 card flex flex-wrap justify-content-center gap-3 my-4">
        
        <DataTable :value="devicesData" stripedRows paginator :rows="5" 
          tableStyle="min-width: 20rem" class="p-datatable-sm mx-5 shadow-5 border-round-3xl col-12 p-3 color-0" removableSort 
          v-model:editingRows="editingRows" editMode="row" @row-edit-save="onRowEditSave"
          v-model:filters="filters" :globalFilterFields="['ip', 'name']" filterDisplay="menu" > 
            <template #empty>
              <i class="pi pi-ban" style="font-size: 20px" />
              There are no devices!
            </template>

            <Column field="ip" header="IP" sortable style="width: 10%" >
              <template #filter="{ filterModel }">
                <InputText v-model="filterModel.value" type="text" class="p-column-filter" placeholder="Search by IP" />
              </template>
              <template #body="{ data, field }">
                {{ data[field] }}
              </template>
              <template #editor="{ data, field }">
                <InputText v-model="data[field]" class="w-full"/>
              </template>
            </Column>
            <Column field="name" header="Device" style="width: 15%" >
              <template #filter="{ filterModel }">
                <InputText v-model="filterModel.value" type="text" class="p-column-filter" placeholder="Search by Device" />
              </template>
              <template #body="{ data, field }">
                {{ data[field] }}
              </template>
              <template #editor="{ data, field }">
                <InputText v-model="data[field]" class="w-full"/>
              </template>
            </Column>
            <Column field="services" header="Service" style="width: 15%" >
              <template #body="{ data, field }">
                <p v-for="service in data[field]">{{ service }}</p>
              </template>
            </Column>
            <Column field="ports" header="Port" style="width: 15%" >
              <template #body="{ data, field }">
                <p v-for="port in data[field]">{{ port }}</p>
              </template>
              <template #editor="{ data, field }">
                <div v-for="(port, i) in data[field]" :key="port.id">
                  <InputText v-model="data[field][i]" class="w-full"></InputText >
                </div>
              </template>
            </Column>
            <Column field="usernames" header="Username" style="width: 15%" >
              <template #body="{ data, field }">
                <p v-for="username in data[field]">{{ username }}</p>
              </template>
              <template #editor="{ data, field }">
                <div v-for="(username, i) in data[field]" :key="username.id">
                  <InputText v-model="data[field][i]" class="w-full"></InputText >
                </div>
              </template>
            </Column>
            <Column field="passwords" header="Password" style="width: 15%" >
              <template #body="{ data, field }">
                <p v-for="password in data[field]">{{ password }}</p>
              </template>
              <template #editor="{ data, field }">
                <div v-for="(password, i) in data[field]" :key="password.id">
                  <InputText v-model="data[field][i]" class="w-full"></InputText >
                </div>
              </template>
            </Column>
            <Column field="services" header="" style="width: 5%" >
              <template #body="{ data, field }">
                <!-- <p v-for="password in data[field]">{{ password }}</p> -->
                
              </template>
              <template #editor="{ data, field }">
                <div class="flex flex-column gap-4 justify-content-center align-items-center">
                  <i v-for="(service, i) in data[field]" @click="deleteService(data, i)" class="pi pi-times text-red-500 cursor-pointer" style="font-size: 20px" v-tooltip.top="'Delete Service'" />
                </div>
              </template>
            </Column>

            <Column :rowEditor="true" style="width: 10%" bodyStyle="text-align:center"></Column>
            <Column style="width: 5%" bodyStyle="text-align:center">
              <template #body="{ data }">
                <a href="#" @click="deleteDevice(data.id)" v-tooltip.top="'Delete'">
                  <i class="pi pi-trash text-500" style="font-size: 20px" />
                </a>
              </template>
            </Column>
          </DataTable>

      </div>
    </div>




    <!-- Toast -->
    <Toast/>
  </div>

</template>