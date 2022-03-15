
<template>
  <div v-loading="loading" class="profession-proportion">
    <div :id="chartId" class="mapEchart"></div>
    <div class="num">
      <div>{{ title }}</div>
      <div class="pienum">{{ pienum }}</div>
    </div>
  </div>
</template>

<script >
import Vue from "vue";
import { getItemProfessionProportionList } from "./api";
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
        const data = await getItemProfessionProportionList(params);
        let chartsData = [];
        for (let i = 0; i < data.length; i++) {
          console.log(data[i]);
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
        color: [
          "#2983FF ",
          "#03C3EB",
          "#753BF7",
          "#FD5CA0",
          "#FFBB01",
          "#FF7C79",
          "#1FDAB9 ",
        ],
        series: [
          {
            name: "Access From",
            type: "pie",
            radius: ["40%", "70%"],
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
      let that = this;
      mapchart.on("mouseover", function (params) {
        that.title = params.name;
        that.pienum = params.value + "(" + params.percent + "%)";
        console.log(this.title, this.pienum);
      });
    },
  },
});
</script>

<style scoped lang="less">
.profession-proportion {
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
  // width: calc(~"58%");
  width: 100%;
  height: 100%;
}
.num {
  width: 200px;
  position: absolute;
  top: 233px;
   left: calc((100% - 200px) / 2);
  text-align: center;
  font-size: 30px;
}
.pienum {
  color: red;
}
</style>

