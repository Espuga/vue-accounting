<script setup>
// =============================
//          Import
import { ref, onMounted, inject, watch } from 'vue';
import { use } from "echarts/core";
import { useToast } from "primevue/usetoast";
import * as echarts from 'echarts';
import { CanvasRenderer } from "echarts/renderers";
import { LineChart, BarChart } from "echarts/charts";
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent,
} from "echarts/components";
import VChart from "vue-echarts";
import axios from 'axios';
import { FilterMatchMode } from 'primevue/api';

use([
  CanvasRenderer,
  LineChart,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
]);

// =============================
//          Const

// GENERAL
const toast = useToast();
const selectedGroup = inject('selectedGroup')

// GLOBAL
const group = inject('selectedGroup')
const sprints = ref(null)

// MAIN CHART
const chartData = ref();

// DATA TABLE
const originalDataTable = ref(null)
const dataDataTable = ref(null)
const transactionDataExport = ref()
const editingRows = ref([]);

// loading
const loading = ref(false)

// =============================
//          Functions

// GET CHART DATA
const getChart = () => {
  try {
    let gr = group.data.value.id
    loading.value = true
    axios.get(import.meta.env.VITE_APP_BACKEND_IP + '/accounting/getInit', { params: { groupId: gr } })
      .then((res) => {
        loading.value = false
        if(res.data.ok){

          chartData.value = {
            tooltip: { trigger: 'axis' },
            legend: { data: ['Added Funds', 'Withdrawed Funds', 'Global Funds'] },
            grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
            xAxis: { type: 'category', data: res.data.dataChart.dates },
            toolbox: { feature: { saveAsImage: { name: getFileName(true) } } },
            yAxis: [
              { type: 'value', name: 'Funds', axisLabel: { formatter: '{value} €' } },
              { type: 'value', name: 'Global Funds', axisLabel: { formatter: '{value} €' } }
            ],
            series: [
              {
                name: 'Added Funds', type: 'line', symbolSize: 0, lineStyle: { width: 5 },
                itemStyle: { borderWidth: 5, color: '#72D812' },
                data: res.data.dataChart.addedData
              },
              {
                name: 'Withdrawed Funds', type: 'line', symbolSize: 0, lineStyle: { width: 5 },
                itemStyle: { borderWidth: 5, color: 'red' },
                data: res.data.dataChart.withdrawedData
              },
              {
                name: 'Global Funds', type: 'bar', yAxisIndex: 1,
                itemStyle: {
                  color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                    { offset: 0, color: '#83bff6' },
                    { offset: 0.5, color: '#188df0' },
                    { offset: 1, color: '#188df0' }
                  ])
                },
                data:res.data.dataChart.totalData,
              }
            ]
          };
          dataDataTable.value = res.data.dataTable
          originalDataTable.value = res.data.dataTable

        }
      })

  }catch (er){
    console.error(er)
    toast.add({ severity: 'warn', summary: 'No Groups!', detail: 'You are not in any group.', life: 4000 });
  }
}

// EXPORT TABLE
const exportTable = () => {
  transactionDataExport.value.exportCSV();
}

// GET NAME TO DOWNLOAD
const getFileName = (chart) => {
  var now = new Date()
  var date = now.getDate()+"-"+now.getMonth()+"-"+now.getFullYear()
  return group.data.value.name + '_accounting_' + (chart ? 'chart_' : '') + date
}

const getSprints = () => {
  axios.get(import.meta.env.VITE_APP_BACKEND_IP + "/accounting/getSprints")
    .then((res) => {
      if(res.data.ok) {
        sprints.value = res.data.sprints
      }
    })
}

const clickChart = (data) => {
  let start = new Date()
  let end = new Date()
  sprints.value.forEach((sprint) => {
    if(sprint.name == data.name) {
      start = new Date(sprint.start)
      end = new Date(sprint.end)
      return;
    }
  })
  dataDataTable.value = []
  originalDataTable.value.forEach((da) => {
    let dat = new Date(da.data)
    if(dat >= start && dat <= end) {
      dataDataTable.value.push(da)
    }
  })
}

const onRowEditSave = (event) => {
  let { newData, index } = event
  let obj = {id: newData.id, title: newData.title, description: newData.description, amount: newData.amount, data: newData.data, groupId: group.data.value.id}
  // Integer id, String title, String description, Double amount, String data, Integer groupId
  axios.post(import.meta.env.VITE_APP_BACKEND_IP + "/accounting/updateTransaction", obj)
    .then((res) => {
      if(res.data) {
        toast.add({ severity: 'success', summary: 'Saved!', detail: 'Transaction saved successfully.', life: 4000 });
        getChart()
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error saving the transaction.', life: 4000 });
      }
    })
};

const deleteTransaction = (id) => {
  axios.delete(import.meta.env.VITE_APP_BACKEND_IP + "/accounting/deleteTransaction/"+group.data.value.id+"/"+id)
    .then((res) => {
      if(res.data) {
        toast.add({ severity: 'success', summary: 'Deleted!', detail: 'Transaction deleted successfully.', life: 4000 });
        getChart()
      }else {
        toast.add({ severity: 'error', summary: 'Error!', detail: 'Error deletting the transaction.', life: 4000 });
      }
    })
}



// ON MOUNTED
onMounted(() => {
  document.title = "Accounting - Dashboard"
  getChart()
  getSprints()
})


watch(() => selectedGroup.data.value, getChart);

const filters = ref({
  global: { value: null, matchMode: FilterMatchMode.CONTAINS },
  id: { value: null, matchMode: FilterMatchMode.EQUALS },
  title: { value: null, matchMode: FilterMatchMode.CONTAINS },
  description: { value: null, matchMode: FilterMatchMode.CONTAINS },
  amount: { value: null, matchMode: FilterMatchMode.CONTAINS },
  user: { value: null, matchMode: FilterMatchMode.CONTAINS },
  data: { value: null, matchMode: FilterMatchMode.CONTAINS }
});
</script>


<template>
  <div class="flex flex-column" >
    <div class="grid">

      <!-- ACCOUNTING CHART -->
      <div class="col-12">
        <Panel header="Header" ref="cardGridFi" :collapsed="false" :pt="{
            header: { class: 'bg-bluegray-50 border-round-top-xl shadow-8' },
            content: { class: 'bg-bluegray-50 border-round-bottom-3xl shadow-8' }
          }">
          <template #header>
            <div class="flex align-items-center">
              <i class="pi pi-chart-bar" style="font-size: 20px" />
              <span class="text-lg ml-2"> Accounting {{ group.data.value.name }} </span>
            </div>
          </template>
          <!-- CHART -->
          <div class="responsive" style="height: 30vh; clientHeight: 30vh">
            <v-chart class="chart" @click="clickChart" :option="chartData" autoresize/>
          </div>
        </Panel>
      </div>

      <!-- ACCOUNTING TABLE -->
      <div class="col-12">
        <Panel header="Header" ref="cardGridFi" :collapsed="false" :pt="{
            header: { class: 'bg-bluegray-50 border-round-top-xl shadow-8' },
            content: { class: 'bg-bluegray-50 border-round-bottom-3xl shadow-8' }
          }">
          <template #header>
            <div class="flex align-items-center">
              <i class="pi pi-database" style="font-size: 20px" />
              <span class="text-lg ml-2"> Accounting {{ group.data.value.name }} </span>
            </div>
          </template>
          <!-- TABLE -->
          <DataTable v-model:filters="filters" filterDisplay="row" :globalFilterFields="['id', 'title', 'description', 'amount', 'user', 'data']" 
          :value="dataDataTable" stripedRows paginator :rows="7" 
          :exportFilename="getFileName(false)" ref="transactionDataExport" 
          tableStyle="min-width: 20rem" class="p-datatable-sm" 
          :rowClass="({ amount }) => amount > 0 ? 'text-green-500': 'text-red-500'" removableSort 
          v-model:editingRows="editingRows" editMode="row" @row-edit-save="onRowEditSave"> 
            <template #header>
              <div class="flex justify-content-end">
                <IconField iconPosition="left">
                  <InputIcon>
                    <i class="pi pi-search" />
                  </InputIcon>
                  <InputText v-model="filters['global'].value" placeholder="Keyword Search" />
                </IconField>
              </div>
            </template>
            <template #paginatorstart>
              <Button @click="dataDataTable = originalDataTable" type="button" icon="pi pi-refresh" text />
            </template>
            <template #paginatorend>
              <Button type="button" icon="pi pi-download" @click="exportTable($event)" text />
            </template>
            <template #empty>
              <i class="pi pi-ban" style="font-size: 20px" />
              There are no transactions in {{ group.data.value.name }}
            </template>
            <Column field="id" header="Id" style="width: 5%" class="text-900" ></Column>
            <Column field="title" header="Title" style="width: 20%" class="text-900">
              <template #body="{ data, field }">
                {{ data[field] }}
              </template>
              <template #editor="{ data, field }">
                <InputText v-model="data[field]"/>
              </template>
            </Column>
            <Column field="description" header="Description" style="width: 40%" class="text-900">
              <template #body="{ data, field }">
                {{ data[field] }}
              </template>
              <template #editor="{ data, field }">
                <Textarea v-model="data[field]" class="w-full"/>
              </template>
            </Column>
            <Column field="amount" header="Amount" sortable style="width: 10%" >
              <template #body="{ data, field }">
                {{ data[field] }}
              </template>
              <template #editor="{ data, field }">
                <InputNumber v-model="data[field]" />
              </template>
            </Column>
            <Column field="name" header="User" style="width: 10%" class="text-900"></Column>
            <Column field="data" header="Data" sortable style="width: 15%" class="text-900">
              <template #body="{ data, field }">
                {{ data[field] }}
              </template>
              <template #editor="{ data, field }">
                <Calendar v-model="data[field]" dateFormat="yy-mm-dd" />
              </template>
            </Column>
            <Column :rowEditor="true" style="width: 3%" bodyStyle="text-align:center"></Column>
            <Column style="width: 3%" bodyStyle="text-align:center">
              <template #body="{ data }">
                <a href="#" @click="deleteTransaction(data.id)">
                  <i class="pi pi-trash text-500" style="font-size: 20px" />
                </a>
              </template>
            </Column>
          </DataTable>
        </Panel>
      </div>


    </div>
    <!-- LOADING PROGRESS SPINNER -->
    <Dialog v-model:visible="loading" header="Loading..." modal :closable="false">
      <ProgressSpinner />
    </Dialog>

    <!-- TOAST -->
    <Toast />
  </div>
</template>