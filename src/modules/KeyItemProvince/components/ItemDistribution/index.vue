
<template>
  <div class="map-item">
    <div :id="chartId" class="mapEchart"></div>
    <div class="generalsituation">
      <div class="textTitle">总体情况</div>
      <div class="generalsituationContent">
        <NbDescription :description="description" :attrs="attrs" />
      </div>
    </div>
  </div>
</template>

<script >
import Vue from "vue";
import api from "./api";
import { v4 as uuidv4 } from "uuid";
import { registerMap, init } from "echarts";
import { ConfigUtil } from "@newboss/nb-common";
import moment from "moment";
import NbDescription from '@/components/NbDescription.vue'
export default Vue.extend({
  components: {
    NbDescription
  },
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
      description: '${reportYear}省重点项目${totalCount}, 总投资${totalAmt}, 年度计划投资${totalPlanAmt}. '+
      '其中: 在建项目${zjCount}, 总投资${zjTotalAmt},年度计划投资${zjPlanAmt}, 实际完成投资${zjYearRealAmt}, 占年度计划投资的${zjYearAmtRate}; ' +
      '预备项目${ybCount}, 总投资${ybTotalAmt}, 年度计划投资${ybPlanAmt}. 截止${reportMonth}, 共有${realStartCount}开工, 开工率${startRate}. '+
      '${realEndCount}项目建成或部分建成, 竣工率${endRate}'
      ,
      loading: false,
      overviewAttrs:{},
      dataSource: {},
      chartId: uuidv4(),
      selected: "amt",
      itemCountyList: [],
      color: [],
      activeIndex: null,
      mapLevel: ConfigUtil.getConfig("mapLevel"),
      province: ConfigUtil.getConfig("province"),
      city:
        ConfigUtil.getConfig("mapLevel") === "province"
          ? ConfigUtil.getConfig("province")
          : ConfigUtil.getConfig("city"),

    };
  },
  computed: {
    attrs() {
      return {
        reportYear: this.overviewAttrs.reportYear + '年度', 
        totalCount: this.overviewAttrs.totalCount + '个', 
        totalAmt: this.overviewAttrs.totalAmt + '亿元', 
        totalPlanAmt: this.overviewAttrs.totalPlanAmt + '亿元', 
        zjCount: this.overviewAttrs.zjCount + '个', 
        zjTotalAmt: this.overviewAttrs.zjTotalAmt + '亿元', 
        zjPlanAmt: this.overviewAttrs.zjPlanAmt + '亿元', 
        zjYearRealAmt: this.overviewAttrs.zjYearRealAmt + '亿元', 
        zjYearAmtRate: this.overviewAttrs.zjYearAmtRate + '%', 
        ybCount: this.overviewAttrs.ybCount + '个', 
        ybTotalAmt: this.overviewAttrs.ybTotalAmt + '亿元', 
        ybPlanAmt: this.overviewAttrs.ybPlanAmt + '亿元', 
        reportMonth: this.overviewAttrs.reportMonth + '月', 
        realStartCount: this.overviewAttrs.realStartCount + '个', 
        startRate: this.overviewAttrs.startRate + '%', 
        realEndCount: this.overviewAttrs.realEndCount + '个', 
        endRate: this.overviewAttrs.endRate + '%', 
      }
    }
  },
  created() {
    this.initEchartMap();
  },
  mounted() {
    if (this.date) {
      this.loadData();
    }
  },
  methods: {
    async initEchartMap() {
      let map = await require(`@/assets/geojson/fujian/fujian.json`);
      registerMap(this.city, map);
    },
    async loadData() {
      let params = {
        year: this.date.split("-")[0],
        month: this.date.split("-")[1],
      };
      this.loading = true;
      try {
        const [overviewAttrs, itemCountyList] = await Promise.all([
          api.getOverviewAttribute(params),
          api.getItemCityReport(params)
        ])
        this.overviewAttrs = overviewAttrs;
        this.itemCountyList = itemCountyList.map((v) => {
          if (v.cityName === `平潭综合实验区`) {
            return { ...v, name: `平潭`, value: v.itemCount, itemAmt: v.totalAmt, itemPlanAmt: v.totalPlanAmt };
          } else {
            return {
              ...v,
              name: v.cityName,
              value: v.itemCount,
              itemAmt: v.totalAmt,
              itemPlanAmt: v.totalPlanAmt
            };
          }
        });
        this.initEchart();
      } catch(e) {console.error(e);}
      this.loading = false;
    },
    initEchart() {
      let mapchart = init(document.getElementById(this.chartId));
      let itemData = this.itemCountyList;
      let city = this.city;
      mapchart.setOption(
        // EchartOption.getEchartOption(this.itemCountyList, this.city)
        {
          title: {
            top: 10,
            // text: '省重点项目分布',
            subtext: "",
            x: "center",
            textStyle: {
              color: "#333",
            },
          },

          tooltip: {
            padding: [
              20, // 上
              20, // 右
              20, // 下
              20, // 左
            ],
            trigger: "item",
            backgroundColor: "#042042cc",
            formatter: function (params) {
              if (params.data?.value) {
                return (
                  '<span style="color:#fff">' +
                  params.name +
                  "<br>" +
                  "项目总数: " +
                  params.data.itemCount +
                  " 个" +
                  "<br>" +
                  "总投资: " +
                  params.data?.itemAmt +
                  " 亿元" +
                  "<br>" +
                  "计划投资: " +
                  params.data?.itemPlanAmt +
                  " 亿元" +
                  "<br>" +
                  "</span>"
                );
              } else {
                return '<span style="color:#fff">' + params.name + "</span>";
              }
            },
          },
          legend: {
            // data: ["项目总数", "项目总投资"],
            // top: 35
            show: false,
          },
          visualMap: {
            left: "left",
            top: "10%",
            dimension: 0,
            seriesIndex: 0,
            min: 0,
            max: this.getMax(itemData),
            itemHeight: 95,
            // precision: 'auto',
            calculable: true,
            text: [""],
            textGap: 30,
            inRange: {
              color: ["#B5E8FD", "#0349BB"],
            },
          },
          geo: {
            map: city,
            show: true,
            roam: false,
            label: {
              normal: {
                show: true,
                color: "#333",
                backgroundColor: "transparent",
              },
              emphasis: {
                show: true,
                color: "#fff",
                backgroundColor: "transparent",
              },
            },
            itemStyle: {
              normal: {
                borderColor: "#fff", //线
                shadowColor: "#fff", //外发光
                borderWidth: 2,
                shadowBlur: 1,
              },
              emphasis: {
                areaColor: "#B5E8FD", //悬浮区背景
                borderColor: "#07d1f9", //线
                shadowColor: "#07d1f9", //外发光
                shadowBlur: 5,
              },
            },
          },
          series: [
            {
              // name: "项目总数",
              type: "map",
              map: city,
              geoIndex: 0,
              aspectScale: 0.75, //长宽比
              showLegendSymbol: false, // 存在legend时显示
              selectedMode: false,
              roam: false,
              animation: false,
              label: {
                normal: {
                  show: false,
                  backgroundColor: "transparent",
                },
                emphasis: {
                  show: false,
                  backgroundColor: "transparent",
                },
              },
              data: itemData,
            },
          ],
        }
      );
      this.color = mapchart.getOption().color;
      mapchart.on("mouseover", this.mouseover);
      mapchart.on("mouseout", this.mouseout);
      if (this.penetrateEvent) {
        mapchart.on("dblclick", this.penetrateEvent);
      }
      this.loading = false;
    },
    getMax(array = [], attr) {
      console.log(array,'66666')
      let max = 0;
      
        array.forEach((element) => {
          if (element['value'] > max) {
            max = element['value'];
          }
        });
    
      return max + max * 0.5;
    },
  },
  watch: {
    date: {
      immediate: true,
      handler(value) {
        // console.log(value)
        if (value) {
          this.loadData();
          // this.getItemCityReport();
          // this.getOverviewAttribute();
        }
      },
    },
  },
});
</script>

<style scoped lang="less">
.map-item {
  position: relative;
  display: flex;
  flex-direction: row;
  height: 500px;
  .nb-selected {
    color: #4e71fa;
    border-color: #4e71fa;
  }
  .mapEchart {
    // width: calc(~"58%");
    width: 50%;
    height: 100%;
  }
  .generalsituation {
    width: 50%;
    height: 100%;
  }
  .textTitle {
    width: 486px;
    height: 64px;
    font-size: 24px;
    font-family: PingFangSC-Medium, PingFang SC;
    font-weight: 500;
    color: #333333;
    text-align: center;
    line-height: 64px;
    background: linear-gradient(135deg, transparent 32px, #ffcf59 0) top left,
      linear-gradient(-135deg, transparent 32px, #ffcf59 0) top right,
      linear-gradient(-45deg, transparent 32px, #ffcf59 0) bottom right,
      linear-gradient(45deg, transparent 32px, #ffcf59 0) bottom left;
     background-size: 51% 51%;
    background-repeat: no-repeat;
    margin-left: calc((100% - 485px) / 2);
    margin-top: 65px;
  }
  .generalsituationContent {
    /deep/ .widget-description .value {
      font-size: 24px;
    }
    font-size: 24px;
    width: 80%;
    background: #f2f6ff;
    padding: 20px 31px;
    margin-top: 45px;
    margin-left: calc((10%) / 2);
  }
  .tagName {
    color: #083785;
  }
  .itemCount {
    color: #ff4e4a;
  }
}
</style>

