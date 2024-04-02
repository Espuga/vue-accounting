<script setup>
import { ref, onMounted, inject, watch } from 'vue'
import axios from 'axios'
import IndexedDBService from '../services/IndexedDBService';
import HoursSelector from './../components/hoursSelector.vue';

import { use } from "echarts/core";
import * as echarts from 'echarts';
import { CanvasRenderer } from "echarts/renderers";
import { BarChart } from "echarts/charts";
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
} from "echarts/components";
import VChart from "vue-echarts";
import { useToast } from "primevue/usetoast";

use([
  CanvasRenderer,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
]);


const toast = useToast();
const group = inject('selectedGroup')
const teacher = ref(false)

// SELECTORS
const sprints = ref()
const sprint = ref()
const startDate = ref()
const endDate = ref()
const avui = ref(new Date())
const actual = ref(true)

// Working on
const workingData = ref([])

// Chart
const chartData = ref()
const usersIds = ref()

// DataTable
const chartOptions = ref()
const users = ref()
const projectsData = ref()

// User Details
const userVisible = ref(false)
const userProject = ref()
const userName = ref()
const userProjectChart = ref({
  tooltip: {
    trigger: 'item'
  },
  legend: {
    orient: 'vertical',
    left: 'left'
  },
  series: [
    {
      name: 'Projects',
      type: 'pie',
      radius: '50%',
      data: [
        /* { value: 1048, name: 'Search Engine' },
        { value: 735, name: 'Direct' },
        { value: 580, name: 'Email' },
        { value: 484, name: 'Union Ads' },
        { value: 300, name: 'Video Ads' } */
      ],
      emphasis: {
        itemStyle: {
          shadowBlur: 10,
          shadowOffsetX: 0,
          shadowColor: 'rgba(0, 0, 0, 0.5)'
        }
      }
    }
  ]
})

// Edit project
const projectDialog = ref(false);
const usersList = ref([]) // id, username, name, hours, minutes
const projectId = ref()
const projectTitle = ref()
const projectDescription = ref()
const currentDate = new Date()
const formatDate = ref(currentDate.getFullYear()+"-"+(parseInt(currentDate.getMonth())+1)+"-"+currentDate.getDate())
const projectDate = ref(formatDate)

const getWorkingOn = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/projects/workingOn")
    .then((res) => {
      if(res.data.ok) {
        workingData.value = res.data.working
      } else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error getting the projects are working on.', life: 3000 });
      }
    })
}

const getRights = async () => {
  let rights = await IndexedDBService.obtenerDatos(0)
  if(rights != undefined){
    if(rights.rights.includes(2, 0)) {
      teacher.value = true
      getWorkingOn()
      // getCharat()
    } else {
      teacher.value = false
      // getChart()
    }
  } else {
    teacher.value = false
    // getChart()
  }
}

const clickChart = (data) => {
  let userId = usersIds.value[data.dataIndex]
  userName.value = data.name
  // console.log(userId)
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/projects/getUserInfo", {params: {groupId: group.data.value.id, userId: userId, start: startDate.value, end: endDate.value}})
    .then((res) => {
      if(res.data.ok){
        userProject.value = res.data.userProjects
        userProjectChart.value.series[0].data = []
        res.data.userProjects.forEach((project) => {
          userProjectChart.value.series[0].data.push({name: project.title, value: project.hours})
        })
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error getting the user information.', life: 4000 });
      }
    })

  userVisible.value = true
}

const getSelectors = async () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + "/vmachines/getSelectors")
    .then((res) => {
      if(res.data.ok){
        // priceCpu.value = res.data.priceCpu
        // priceDisk.value = res.data.priceDisk
        sprints.value = res.data.sprints
        // Selecionar sprint actual
        let date = new Date()
        res.data.sprints.forEach((spr) => {
          if(date >= new Date(spr.start) && date <= new Date(spr.end)) {
            sprint.value = spr
            startDate.value = spr.start
            endDate.value = spr.end
            getData()
            // getDataTable()
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
      actual.value = false
      if(avui.value >= new Date(spr.start) && avui.value <= new Date(spr.end)) {
        actual.value = true
      }
      getData()
      // getDataTable()
    }
  })
} 

const getData = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/projects/getProjects", {params: {id: group.data.value.id, start: startDate.value, end: endDate.value}})
    .then((res) => {
      if(res.data.ok) {
        projectsData.value = res.data.projects
        users.value = res.data.users
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error getting the projects.', life: 4000 });
      }
    })
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/projects/getChart", {params: {id: group.data.value.id, start: startDate.value, end: endDate.value}})
    .then((res) => {
      if(res.data.ok) {
        chartOptions.value.xAxis.data = res.data.users
        chartOptions.value.series[0].data = res.data.hours
        chartOptions.value.series[0].itemStyle = { color: '#73BDE9' }
        chartData.value = res.data.hours
        usersIds.value = res.data.usersId
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error getting the projects.', life: 4000 });
      }
    })
}

const mountChart = () => {
  chartOptions.value = {
    tooltip: { trigger: 'axis' },
    // legend: { data: ['Added Funds', 'Withdrawed Funds', 'Global Funds'] },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'category', data: [] },
    yAxis: [
      { type: 'value', name: 'Hours', axisLabel: { formatter: '{value} h' } }
    ],
    series: [
      {
        name: 'Users', type: 'bar',
        data: []
      },
    ]
  };
  getSelectors()
}

const editProject = (data) => {
  projectId.value = data.id
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/projects/getProject", {params: {projectId: data.id}})
    .then((res) => {
      if(res.data.ok){
        projectTitle.value = res.data.title
        projectDescription.value = res.data.description
        projectDate.value = res.data.data
        usersList.value = res.data.userList
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error while getting the project information.', life: 4000 });
        projectDialog.value = false
      }
    })
  projectDialog.value = true
}

const deleteProject = (id) => {
  axios.delete(import.meta.env.VITE_APP_BACKEND_IP+"/projects/deleteProject/"+id)
    .then((res) => {
      if(res.data) {
        toast.add({ severity: 'success', summary: 'Deleted!', detail: 'The Project was successfully deleted.', life: 4000});
        getData()
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error while deleting the project.', life: 4000});
      }
    })
}

const closeprojectDialog = () => {
  projectDialog.value = false
}

const submitProject = () => {
  let hours = {}
  usersList.value.forEach((user) => {
    hours[user.id] = {"hours": user.hours, "minutes": user.minutes}
  })
  let date = new Date(projectDate.value)
  let formatDate = `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
  let obj = {
    title: projectTitle.value, 
    description: projectDescription.value,
    group_id: projectId.value,
    data: formatDate,
    users_hours: hours
  }
  axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/projects/saveProject", obj)
    .then((res) => {
      if(res.data) {
        toast.add({ severity: 'success', summary: 'Saved!', detail: 'The Project was saved.', life: 4000 });
        projectDialog.value = false
        getData()
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error saving the project.', life: 4000 });
      }
    })
}


onMounted(() => {
  document.title = "Projects"
  getRights()
  mountChart()
})

watch(() => group.data.value, mountChart);
</script>

<template>
   <div class="flex flex-column" >
    <div class="grid">
      <!-- SELECTORS -->
      <div class="col-12">
        <div class="col-12 ml-1 grid color-0 border-round-xl justify-content-center gap-3 shadow-5">
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
        </div>
      </div>
      <!-- ENDS SELECTORS -->

      <!-- PROFE VEURE EN QUE ESTAN TREBALLAN -->
      <div v-if="teacher" class="col-12"><!-- USERS CHART -->
        <Panel header="Header" ref="cardGridFi" toggleable :pt="{
            header: { class: 'color-1 border-round-top-xl shadow-5' },
            content: { class: 'color-0 border-round-bottom-3xl shadow-5' }
          }">
          <template #header>
            <div class="flex align-items-center">
              <i class="pi pi-clock" style="font-size: 20px" />
              <span class="text-lg ml-2"> Working on </span>
            </div>
          </template>
          <DataTable :value="workingData" :rows="5" tableStyle="min-width: 50rem">
            <template #empty>
              <i class="pi pi-ban" style="font-size: 20px" />
              There aren't working in any projects!
            </template>
            <Column field="name" header="Name"></Column>
            <Column field="group" header="Group"></Column>
            <Column field="project" header="Project"></Column>
            <Column field="start" header="Started"></Column>
            <Column field="time" header="Time"></Column>
          </DataTable>
        </Panel>
      </div>
      <!-- FI EN QUE ESTAN TREBALLAN -->

      <div class="col-12"><!-- USERS CHART -->
        <Panel header="Header" ref="cardGridFi" :collapsed="false" :pt="{
            header: { class: 'color-1 border-round-top-xl shadow-5' },
            content: { class: 'color-0 border-round-bottom-3xl shadow-5' }
          }">
          <template #header>
            <div class="flex align-items-center">
              <i class="pi pi-users" style="font-size: 20px" />
              <span class="text-lg ml-2"> {{ group.data.value.nom }}'s members </span>
            </div>
          </template>
          <!-- CHART -->
          <div class="responsive" style="height: 30vh; clientHeight: 30vh">
            <v-chart class="chart" @click="clickChart" :option="chartOptions" autoresize/>
          </div>
        </Panel>
      </div><!-- USERS CHART -->

      <div class="col-12"><!-- PROJECTS GRID -->
        <Panel header="Header" ref="cardGridFi" :collapsed="false" :pt="{
            header: { class: 'color-1 border-round-top-xl shadow-5' },
            content: { class: 'color-0 border-round-bottom-3xl shadow-5' }
          }">
          <template #header>
            <div class="flex align-items-center">
              <i class="pi pi-database" style="font-size: 20px" />
              <span class="text-lg ml-2"> {{ group.data.value.nom }}'s projects </span>
            </div>
          </template>
          <!-- TABLE -->
          <DataTable :value="projectsData" stripedRows paginator :rows="7" 
          tableStyle="min-width: 20rem" class="p-datatable-sm" removableSort > 
            <template #empty>
              <i class="pi pi-ban" style="font-size: 20px" />
              There are no projects in {{ group.data.value.name }}
            </template>
            <Column field="id" header="Id" style="width: 5%" ></Column>
            <Column field="title" header="Title" style="width: 20%" ></Column>
            <Column field="description" header="Description" style="width: 40%" ></Column>
            <Column field="data" header="Date" style="width: 10%" ></Column>
            <Column v-for="user of users" :field="user.username" :header="user.name"></Column>
            <Column v-if="actual || teacher" style="width: 3%" bodyStyle="text-align:center">
              <template #body="{ data }">
                <a href="#" @click="editProject(data)" v-tooltip.top="'Edit'">
                  <i class="pi pi-pencil text-500" style="font-size: 20px" />
                </a>
              </template>
            </Column>
            <Column v-if="teacher" style="width: 3%" bodyStyle="text-align:center">
              <template #body="{ data }">
                <a href="#" @click="deleteProject(data.id)" v-tooltip.top="'Delete'">
                  <i class="pi pi-trash text-500" style="font-size: 20px" />
                </a>
              </template>
            </Column>
          </DataTable>
        </Panel>
      </div><!-- PROJECTS GRID -->

      <Dialog v-model:visible="userVisible" maximizable modal header="User Information" :style="{ width: '80rem' }" :breakpoints="{ '1199px': '75vw', '575px': '90vw' }">
        <template #header>
          <div class="text-3xl flex align-items-center">
            <i class="pi pi-info-circle mr-2" style="font-size: 2rem" />
            {{ userName }}'s Information
          </div>
        </template>
        <div class="grid color-0 shadow-3 border-round-xl pb-3 mt-2">
          <!-- USER TABLE -->
          <div class="col-6">
            <DataTable :value="userProject" stripedRows paginator :rows="10" 
              tableStyle="min-width: 20rem" class="p-datatable-sm shadow-3 border-round-xl color-1" removableSort > 
              <template #empty>
                <i class="pi pi-ban" style="font-size: 20px" />
                There are no projects
              </template>
              <Column field="title" header="Title" style="width: 80%"></Column>
              <Column field="hours" header="Hours" style="width: 20%"></Column>
            </DataTable>
          </div>
          <!-- END USER TABLE -->
          <Divider layout="vertical" class="m-0"/>
          <!-- USER CHART -->
          <div class="col-6">
            <div class="responsive shadow-3 border-round-xl color-1" style="height: 50vh; clientHeight: 50vh">
              <v-chart class="chart" :option="userProjectChart" autoresize/>
            </div>
          </div>
          <!-- END USER CHART -->
        </div>
      </Dialog>





      <!-- editProjectView -->
      <Dialog v-model:visible="projectDialog" modal :closable="false" :style="{ width: '50rem' }" 
      :breakpoints="{ '1199px': '75vw', '575px': '90vw' } ">
        <!-- HEADER -->
        <template #header>
          <div class="flex align-items-center">
            <i class="pi pi-pencil" style="font-size: 1.5rem"></i>
            <b class="text-2xl ml-2">Edit Project</b>
          </div>
        </template>
        <!-- MAIN CONTENT -->

        <div class="mt-4 color-1 shadow-3 border-round-xl pb-3 pt-4">
          <div class="d-flex">
            <div class="col-12 w-full">
              <span class="col-12"> 
                <label for="title">Title</label>
                <InputText v-model="projectTitle" class="w-full mt-1" />
              </span>
            </div>
            <div class="col-12 w-full">
              <span class="col-12">
                <label for="description">Description</label>
                <Textarea v-model="projectDescription" autoResize rows="5" cols="30" class="w-full mt-1" />
              </span>
            </div>
          </div>
          
          <div class="d-flex m-2 border-round-xl">
            <DataView :value="usersList" scrollable :pt="{
              content: { class: 'border-round-xl shadow-2' }
            }">
              <template #list="slotProps">
                <div class="grid grid-nogutter">
                  <div v-for="(item, index) in slotProps.items" :key="index" class="col-12">
                    <div class="flex flex-column xl:flex-row xl:align-items-center pl-4 pr-4 pt-2 pb-2 gap-4" :class="{ 'border-top-1 surface-border': index !== 0 }">
                      <i class="pi pi-user" style="font-size: 2rem"></i>
                      <div class="flex flex-column sm:flex-row justify-content-between align-items-center flex-1 gap-4">
                        <div class="">{{ item.name }}</div>
                        <div class="flex align-items-center sm:align-items-end gap-3 sm:gap-2">
                          
                          <HoursSelector :item="item"></HoursSelector>

                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </template>
            </DataView>

            <div class="card flex ml-2 mr-5 mt-2 justify-content-right">
              <Calendar v-model="projectDate" dateFormat="yy-mm-dd" />
            </div >
          </div>

        </div>
        <!-- FOOTER -->
        <template #footer>
          <div class="flex justify-content-center w-full gap-3">
            <Button label="Cancel" icon="pi pi-times" @click="closeprojectDialog" class="surface-300 border-400 text-black-alpha-90"/>
            <Button label="Save" icon="pi pi-save" @click="submitProject" class="color-light-green text-green-500 border-green-600"/>
          </div>
        </template>
      </Dialog>





     </div>
    <Toast/>
  </div>
</template>