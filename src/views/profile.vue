<script setup>
import { ref, onMounted, inject } from 'vue'
import axios from 'axios'

import { use } from "echarts/core";
import * as echarts from 'echarts';
import { CanvasRenderer } from "echarts/renderers";
import { LineChart } from "echarts/charts";
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
} from "echarts/components";
import VChart from "vue-echarts";
import { useToast } from "primevue/usetoast";
import ChangeProfileImgComponent from '../components/settings/changeProfileImgComponent.vue';

use([
  CanvasRenderer,
  LineChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
]);

const toast = inject('toast')
const loading = inject('loading')

const id = ref()
const name = ref("")
const username = ref("")
const img = ref("")
const course = ref("")
const amount = ref(0)
const worked_hours = ref(0)

const editName = ref(false)

const sprints = ref()
const sprints2 = ref()
const salary = ref({
  tooltip: { trigger: 'axis' },
  grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
  xAxis: { type: 'category', data: [] },
  yAxis: [
    { type: 'value', name: '€', axisLabel: { formatter: '{value} €' } }
  ],
  series: [
    {
      name: 'Salary', type: 'line', symbolSize: 0, lineStyle: { width: 5 },
      itemStyle: { borderWidth: 5, color: '#8FEC59' },
      data: []
    },
  ]
})
const salaryTable = ref()
const salaryTableSelected = ref()
const projects = ref({
  tooltip: { trigger: 'axis' },
  grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
  xAxis: { type: 'category', data: [] },
  yAxis: [
    { type: 'value', name: 'Hours', axisLabel: { formatter: '{value} h' } }
  ],
  series: [
    {
      name: 'Projects', type: 'line', symbolSize: 0, lineStyle: { width: 5 },
      itemStyle: { borderWidth: 5, color: '#73BDE9' },
      data: []
    },
  ]
})
const projectsTable = ref()
const projectsTableSelected = ref()

const changeName = () => {
  editName.value = true
}

const saveName = () => {
  axios.post(import.meta.env.VITE_APP_BACKEND_IP+"/auth/changeName", new URLSearchParams({ token: window.$cookies.get("auth"), name: name.value }))
    .then((res) => {
      if(res.data) {
        toast.toast('success', 'Saved!', '')
        editName.value = false
      }else {
        toast.toast('error', 'Error!', 'Error changing the name.')
      }
    })
}

const loadMain = () => {
  loading.load(true)
  axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/auth/getInfo", { params: { token: window.$cookies.get("auth") } })
    .then((res) => {
      loading.load(false)
      if(res.data.ok) {
        id.value = res.data.id
        name.value = res.data.name
        img.value = res.data.img
        username.value = res.data.username

        axios.get(import.meta.env.VITE_APP_BACKEND_IP+"/user/info2", { params: { token: window.$cookies.get("auth") } })
          .then((res) => {
            if(res.data.ok) {
              console.log(res.data)

              course.value = res.data.course

              sprints.value = res.data.sprints
              sprints2.value = res.data.sprints2

              salary.value.xAxis.data = res.data.sprints
              salary.value.series[0].data = res.data.salary
              salaryTable.value = res.data.salaryTable
              salaryTable.value.forEach((row) => {
                if(row.id == id.value) {
                  salaryTableSelected.value = row
                }
              })

              projects.value.xAxis.data = res.data.sprints
              projects.value.series[0].data = res.data.projects
              projectsTable.value = res.data.projectsTable
              projectsTable.value.forEach((row) => {
                if(row.id == id.value) {
                  projectsTableSelected.value = row
                }
              })

              amount.value = res.data.amount
              worked_hours.value = res.data.hours

            }else {
              toast.toast('error', 'Error!', 'Error getting your information')
            }
          })

      } else {
        toast.toast('error', 'Error!', 'Error getting your information')
      }
    })
}

onMounted(() => {
  loadMain()
})

</script>

<template>
  <div class="card ml-4 mr-4 pl-4 pr-4 pt-4">
    <div class="ml-8 mr-8 px-4 pt-4 pb-6 shadow-5 border-round-2xl color-0 flex flex-column">
      <div class="col-12 flex">
        <div class="col-2 flex justify-content-center align-items-center">
          <img v-if="img!=''" :src="img" class="border-circle w-full border-3"/>
          <i v-else class="pi pi-user mr-2" style="font-size: 8rem"></i>
        </div>
        <div class="col-10">
          <div class="flex justify-content-between">
            <div class="flex align-items-center">
              <h1 v-if="!editName" class="m-0 inline">{{ name }}</h1>
              <InputText v-else @keyup.enter="saveName" @keyup.esc="editName=false" type="text" v-model="name" autofocus />
              <i  v-if="!editName" @click="changeName" class="pi pi-pencil ml-2 cursor-pointer scale-1" style="font-size: 1.2rem"></i>
            </div>
            <!-- change profile img dialog -->
            <ChangeProfileImgComponent @changed="loadMain"></ChangeProfileImgComponent>

          </div>
          <p class="mb-1 mt-0">@{{ username }}</p>
          <div>
            <p class="mt-0 border-round-xl color-1 inline px-2 border-black-1 text-gray-1">{{ (course=="1" ? "1st" : "2nd") }}</p>
          </div>
          <p class="mb-0 mt-3 font-bold text-xl">Amount: <p class="text-light-green inline text-2xl">{{ amount }}</p> €</p>
          <p class="my-0 font-bold text-xl">Worked hours: <p class="text-light-green inline text-2xl">{{ worked_hours }}</p> h</p>
        </div>
      </div>
      <div class="col-12">
        <TabView class="shadow-2 border-round-3xl">
          <TabPanel header="Salary">
            <div class="responsive" style="height: 30vh; clientHeight: 30vh">
              <v-chart class="chart" :option="salary" autoresize/>
            </div>
            <DataTable v-model:selection="salaryTableSelected" :value="salaryTable" tableStyle="min-width: 20rem" selectionMode="single"
              sortField="total" :sortOrder="-1" class="p-datatable-sm">
              <Column field="name" header="Name"></Column>
              <Column v-for="k of sprints2" :key="k" :field="k" :header="k" sortable></Column>
              <Column field="total" header="Total" sortable></Column>
            </DataTable>
          </TabPanel>
          <TabPanel header="Projects">
            <div class="responsive" style="height: 30vh; clientHeight: 30vh">
              <v-chart class="chart" :option="projects" autoresize/>
            </div>
            <DataTable v-model:selection="projectsTableSelected" :value="projectsTable" tableStyle="min-width: 20rem" selectionMode="single"
              sortField="total" :sortOrder="-1" class="p-datatable-sm">
              <Column field="name" header="Name"></Column>
              <Column v-for="k of sprints2" :key="k" :field="k" :header="k" sortable></Column>
              <Column field="total" header="Total" sortable></Column>
            </DataTable>

            <!-- <DataTable v-model:selection="projectsTableSelected" :value="projectsTable" selectionMode="single"
              tableStyle="min-width: 20rem">
              <Column v-for="k of sprints" :key="k" :field="k" :header="k"></Column>
            </DataTable> -->

          </TabPanel>
        </TabView>
      </div>
    </div>
  </div>
</template>