import { itemFormItemInScheduleFormItem } from "@/modules/Theme/common/schedule"
export { getItemInfoInSchedule,  } from "@/modules/Theme/common/schedule"
import { getStartAndEndScheduleGroupConfig } from '@/modules/Theme/common/schedule'
import { THEME } from "./index";

export const scheduleRules = {
  itemEvolve: [{required: true, message: '实际形象调度不能为空'}],
  zdPlanRebar: [{required: true, message: '年计划钢材采购量不能为空'}],
  zdRealRebar: [{required: true, message: '当月采购量不能为空'}],
  zdRealRebarInPro: [{required: true, message: '其中:省内采购不能为空'}],
  zdYearRealRebar: [{required: true, message: '本年累计钢材采购量不能为空'}],
  zdPlanCement: [{required: true, message: '年计划水泥采购量不能为空'}],
  zdRealCement: [{required: true, message: '当月采购量不能为空'}],
  zdRealCementInPro: [{required: true, message: '其中:省内采购不能为空'}],
  zdYearRealCement: [{required: true, message: '本年累计水泥采购量不能为空'}],
  zdPlanSand: [{required: true, message: '当月需求量不能为空'}],
  zdRealSand: [{required: true, message: '当月实际采购量不能为空'}],
  scPlanStartDate: [{required: true, message: '计划开工日期未选择'}],
  scPlanEndDate: [{required: true, message: '计划竣工日期未选择'}],
  realAmt: [{required: true, message: '本月已完成投资不能为空'}],
  yearRealAmt: [{required: true, message: '本年累计投资不能为空'}],
  itemRealAmt: [{required: true, message: '项目累计投资不能为空'}],
}






export const getScheduleConfigGroup = (vm, ) => {
  return [
    {
      title: `基础信息`,
      children: [
        ...itemFormItemInScheduleFormItem,
      ],
    },
    {
      title: `形象调度与发展情况`,
      children: [
        { label: `实际形象调度`, prop: `itemEvolve`, type: 'textarea', span: 24},
        { label: `调度附件`, prop: `attUploader`, type: 'slot', span: 24},
      ],
    },
    {
      title: `本月已完成投资(万元)`,
      children: [
        { label: `本月已完成投资`, prop: `realAmt`, type: 'number'},
        { label: `本年累计投资`, prop: `yearRealAmt`, type: 'slot', disabled: true},
        { label: `项目累计投资`, prop: `itemRealAmt`, type: 'slot', disabled: true},
      ],
    },
    {
      title: `钢材采购情况(吨)`,
      children: [
        { label: `年计划钢材采购量`, prop: `zdPlanRebar`, type: 'number'},
        { label: `当月采购量`, prop: `zdRealRebar`, type: 'number'},
        { label: `其中:省内采购`, prop: `zdRealRebarInPro`, type: 'number'},
        { label: `本年累计钢材采购量`, prop: `zdYearRealRebar`, type: 'slot', disabled: true},
      ],
    },
    {
      title: `水泥采购情况(吨)`,
      children: [
        { label: `年计划水泥采购量`, prop: `zdPlanCement`, type: 'number'},
        { label: `当月采购量`, prop: `zdRealCement`, type: 'number'},
        { label: `其中:省内采购`, prop: `zdRealCementInPro`, type: 'number'},
        { label: `本年累计水泥采购量`, prop: `zdYearRealCement`, type: 'slot', disabled: true},
      ],
    },
    {
      title: `砂石采购情况(方)`,
      children: [
        { label: `当月需求量`, prop: `zdPlanSand`, type: 'number'},
        { label: `当月实际采购量`, prop: `zdRealSand`, type: 'number'},
      ],
    },
    ...getStartAndEndScheduleGroupConfig(vm, THEME)
  ]
}

export default {
  scheduleRules,
}