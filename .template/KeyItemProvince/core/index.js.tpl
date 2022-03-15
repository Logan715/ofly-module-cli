import { Theme, CommonFlowState } from '@/modules/constant'

import item from './item';
import schedule from './schedule';

import {columnConfig as baseColumnConfig} from '@/modules/BaseItem/core/config';
import { selectColumnsInColumnsConfig } from '@/utils/TableUtil' 

export const THEME = Theme.${FOCUS};
export const FlowState = CommonFlowState;

const columnConfig = {
  tagWfCurState: {label: '审核状态', prop: 'tagWfCurState', fixed: 'left', type: 'dict', customize: {type:'unipmFocusFlowState'}, width: 170, align: 'center'},
  zdLastYearState: {label: '上年省重点类别', prop: 'zdLastYearState', width: 120, align: 'center', type: 'dict', customize: {type: 'unipmZdLastYearState'}},
  zdState: {label: '省重点类别', prop: 'zdState', width: 100, align: 'center', type: 'dict', customize: {type: 'unipmZdState'}},
  zdIndustryCode: {label: '省重点行业', prop: 'zdIndustryCode', width: 160, align: 'center', type: 'dict', customize: {type: 'unipmZdIndustryCode'}, showOverflowTooltip: true},
  zdRespDeptCode: {label: '分级管理单位', prop: 'zdRespDeptCode', width: 150, type: 'org', showOverflowTooltip: true,},
  zdItemIndustry: {label: '产业类型', prop: 'zdItemIndustry', type: 'dict', customize: {type: 'unipmZdItemIndustry'}, align: 'center'},
  zdReviewState: {label: '评审结果', prop: 'zdReviewState', width: 150, type: 'dict', customize: {type: 'unipmZdReviewState'}, align: 'center'},
}

export const MENU_FUNC = {
  SHOW_REVIEW_STATE : "showReviewState", // 显示评审结果 
}

export const getColumns = (columns) => {
  return selectColumnsInColumnsConfig({
    ...baseColumnConfig,
    ...columnConfig
  }, columns)
}


export default {
  THEME,
  FlowState,
  ...item,
  ...schedule,
}