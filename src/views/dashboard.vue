<script setup>
import { ref, onMounted, inject, watch  } from 'vue';
import { use } from "echarts/core";
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
// import axios from 'axios';
use([
  CanvasRenderer,
  LineChart,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
]);

const chartData = ref();

const transactionData = inject('dataTable')
const transactionDataExport = ref()

const labelsChart = inject('labelsChart')
const dataChart = inject('dataChart')
const addedData = inject('addedData')
const withdrawedData = inject('withdrawedData')
const dataChart1 = inject('dataChart1')

const group = inject('selectedGroup')

const updateChart = () => {
  chartData.value = {
    tooltip: { trigger: 'axis' },
    legend: { data: ['Added Founds', 'Withdrawed Founds', 'Global Founds'] },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'category', data: labelsChart.value },
    toolbox: { feature: { saveAsImage: { name: getFileName(true) } } },
    yAxis: [
      { type: 'value', name: 'Founds', axisLabel: { formatter: '{value} €' } },
      { type: 'value', name: 'Global Founds', axisLabel: { formatter: '{value} €' } }
    ],
    series: [
      {
        name: 'Added Founds', type: 'line', symbolSize: 0, smooth: true, lineStyle: { width: 5 },
        itemStyle: { borderWidth: 5, color: '#72D812' },
        data: addedData.value
      },
      {
        name: 'Withdrawed Founds', type: 'line', symbolSize: 0, smooth: true, lineStyle: { width: 5 },
        itemStyle: { borderWidth: 5, color: 'red' },
        data: withdrawedData.value
      },
      {
        name: 'Global Founds', type: 'bar', yAxisIndex: 1,
        itemStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#83bff6' },
            { offset: 0.5, color: '#188df0' },
            { offset: 1, color: '#188df0' }
          ])
        },
        data: dataChart1.value,
      }
    ]
  };
}

const exportTable = () => {
  transactionDataExport.value.exportCSV();
}


onMounted(() => {
  document.title = "Accounting - Dashboard"
  updateChart()
})

const getFileName = (chart) => {
  var now = new Date()
  var date = now.getDate()+"-"+now.getMonth()+"-"+now.getFullYear()
  return group.data.value.name + '_accounting_' + (chart ? 'chart_' : '') + date
}


watch(dataChart, updateChart)
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
            <v-chart class="chart" :option="chartData" autoresize/>
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
          <DataTable :value="transactionData" stripedRows paginator :rows="7" 
          :exportFilename="getFileName(false)" ref="transactionDataExport" 
          tableStyle="min-width: 20rem" class="p-datatable-sm" > 
            <template #paginatorstart></template>
            <template #paginatorend>
              <Button type="button" icon="pi pi-download" @click="exportTable($event)" text />
            </template>
            <Column field="id" header="Id" style="width: 10%"></Column>
            <Column field="title" header="Title"></Column>
            <Column field="description" header="Description"></Column>
            <Column field="amount" header="Amount" sortable></Column>
            <Column field="user" header="User"></Column>
            <Column field="data" header="Data" sortable></Column>
          </DataTable>
        </Panel>
      </div>
    </div>
  </div>
  
</template>