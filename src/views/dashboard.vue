<script setup>
// =============================
//          Import
import { ref, onMounted, inject, watch, provide, watchEffect  } from 'vue';
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

const toast = useToast();

// GLOBAL
const group = inject('selectedGroup')

// MAIN CHART
const chartData = ref();

// DATA TABLE
const dataDataTable = ref(null)
const transactionDataExport = ref()

// loading
const loading = ref(false)

// =============================
//          Functions

// GET CHART DATA
const getChart = (gr) => {
  try {
    if(gr == 0){
      gr = group.data.value.id
    }
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

// ON MOUNTED
onMounted(() => {
  document.title = "Accounting - Dashboard"
  getChart(0)
})


const clickChart = (data) => {
  // console.log(data.name)
}

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
          <DataTable :value="dataDataTable" stripedRows paginator :rows="7" 
          :exportFilename="getFileName(false)" ref="transactionDataExport" 
          tableStyle="min-width: 20rem" class="p-datatable-sm" 
          :rowClass="({ amount }) => amount > 0 ? 'text-green-500': 'text-red-500'" removableSort > 
            <template #paginatorstart></template>
            <template #paginatorend>
              <Button type="button" icon="pi pi-download" @click="exportTable($event)" text />
            </template>
            <!-- <template #empty>
              <i class="pi pi-ban" style="font-size: 20px" />
              There are no transactions in {{ group.data.value.name }}
            </template> -->
            <Column field="id" header="Id" style="width: 5%" class="text-900" ></Column>
            <Column field="title" header="Title" style="width: 20%" class="text-900"></Column>
            <Column field="description" header="Description" style="width: 40%" class="text-900"></Column>
            <Column field="amount" header="Amount" sortable style="width: 10%" ></Column>
            <Column field="name" header="User" style="width: 10%" class="text-900"></Column>
            <Column field="data" header="Data" sortable style="width: 15%" class="text-900"></Column>
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