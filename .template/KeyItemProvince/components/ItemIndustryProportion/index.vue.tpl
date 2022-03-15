
<template>
  <div v-loading="loading" class="industry-proportion">
    <div :id="chartId" class="mapEchart"></div>
  </div>
</template>

<script >
import Vue from "vue";
import { getItemIndustryChart } from "./api";
import { v4 as uuidv4 } from "uuid";
import moment from "moment";
import { init } from "echarts";
export default Vue.extend({
  components: {},

  props: {
    date: {
      type: String,
      default() {
        return moment().format("YYYY-MM");
      },
    },
  },
  data() {
    return {
      loading: false,
      chartsDataList: [],
      chartId: uuidv4(),
      data: [],
      title: "",
      pienum: "",
    };
  },
  watch: {
    date() {
      this.loadData();
    },
  },
  mounted() {
    this.loadData();
  },
  methods: {
    async loadData() {
      let params = {
        year: this.date.split("-")[0],
        month: this.date.split("-")[1],
      };
      this.loading = true;
      try {
        const data = await getItemIndustryChart(params);
        let chartsData = [];
        for (let i = 0; i < data.length; i++) {
          chartsData.push({ value: data[i].totalCount, name: data[i].typeName });
        }
        this.data = chartsData;
        this.initEchart();
      } catch(e) {console.error(e);}
      this.loading = false;
    },
    initEchart() {
      let mapchart = init(document.getElementById(this.chartId));
      mapchart.setOption({
        toolbox: {
          show: false,
          feature: {
            mark: { show: true },
            dataView: { show: true, readOnly: false },
            restore: { show: true },
            saveAsImage: { show: true },
          },
        },
        series: [
          {
            name: "",
            type: "pie",
            radius: [0, 140],
            itemStyle: {
              borderRadius: 0,
            },
            label: {
              show: true,
              overflow: 'break',
              formatter: "{b}\n{c}个({d}%)",
              textStyle: {
                fontSize: 18,
              },
            },
            labelLine: {
              length: 30,
              length2: 0,
              maxSurfaceAngle: 80,
            },
            data: this.data,
          },
        ],
      });
      //let that = this;
      // mapchart.on("mouseover", function (params) {
      //   that.title = params.name;
      //   that.pienum = params.value + "(" + params.percent + "%)";
      //   console.log(this.title, this.pienum);
      // });
    },
  },
});
</script>

<style scoped lang="less">
.industry-proportion {
  display: flex;
  flex-direction: row;
  justify-content: space-evenly;
  align-items: flex-start;
  padding: 10px 0;
  width: 100%;
  height: 539px;
  position: relative;
}
.mapEchart {
  width: 100%;
  height: 100%;
}
</style>

