import { Theme, mobileReg, ZdIndustryType, ZdItemIndustry } from '@/modules/constant'
import { getYears, getYearPropKey, labelReplace } from '@/utils/FormUtil'
const THEME = Theme.${FOCUS};

export const tagCodeSearchItem = {label: '项目标签', prop: 'tagCode', type: 'slot', required: true};
export const getSearchItems = () => {
  const searchItems = [
    {label: '项目名称', prop: 'itemName'},
    {label: '省重点行业', prop: 'zdIndustryCode', type: 'tree-dict', option: { dictKey: 'unipmZdIndustryCode' }},
    {label: '省重点类别', prop: 'zdState', type: 'dict', option: {dictKey: 'unipmZdState'}},
    {label: '分级管理单位', prop: 'zdRespDeptCode', type: `org`},
    {label: '审核状态', prop: 'wfCurState', type: 'dict', option: {dictKey: 'unipmFocusFlowState'}}, 
    {label: '二级责任部门', prop: 'zdSubRespDeptCode', type: `org`},
    {label: '省码', prop: 'itemCode'},
    {label: '建设地点', prop: 'localeCode', type: 'tree-dict', option: { dictKey: 'unipmBuildLocaleCode' }},
    {label: '项目类型', prop: 'itemType', type: 'dict', option: {dictKey: 'unipmItemType'}},
    {label: '总投资(万元) >=', prop: 'totalAmtGe', type: 'number'},
    {label: '总投资(万元) <=', prop: 'totalAmtLe', type: 'number'},
    {label: "创建时间", prop: "submitDate", type: "date", option: { pickerType: "daterange", rangeProps: ["submitDateStart", "submitDateEnd"] } },
    {label: '管理类型', prop: 'zdManageType', type: 'dict', option: {dictKey: 'unipmZdManageType'}},
    {label: '产业类型', prop: 'zdItemIndustry', type: 'dict', option: {dictKey: 'unipmZdItemIndustry'}},
    {label: '上年度省重点类别', prop: 'zdLastYearState', type: 'dict', option: {dictKey: 'unipmZdLastYearState'}},
    {label: '省重点修改状态', prop: 'zdModifyReadState', type: 'dict', option: {dictKey: 'unipmZdModifyReadState'}},
    {label: '业主单位', prop: 'itemOwner'},
    {label: '国码', prop: 'itemCountryCode'},
    {label: '评审结果', prop: 'zdReviewState', type: 'dict', option: {dictKey: 'unipmZdReviewState'}},
  ];
  return searchItems;
}



const yearConfig = {
  title: `省重点项目`,
  themeState: THEME,
  children: [
    { label: `省重点行业`, prop: `zdIndustryCode`, type: `treedict`, dictKey: `unipmZdIndustryCode`, leaf: true},
    { label: `产业类型`, prop: `zdItemIndustry`, type: `dict`, dictKey: `unipmZdItemIndustry`, disabled: true,},
    { label: `产业分类`, prop: `zdIndustryType`, type: `dict`, dictKey: `unipmZdIndustryType`, disabled: true,},
    { label: `管理类型`, prop: `zdManageType`, type: `dict`, dictKey: `unipmZdManageType`},
    { label: `分级管理单位`, prop: `zdRespDeptCode`, type: `org`},
    { label: `分级管理单位姓名`, prop: `zdRespDeptUser` },
    { label: `分级管理单位手机`, prop: `zdRespDeptPhone` },
    { label: `分级管理单位邮箱`, prop: `zdRespDeptEmail` },
    { label: `二级分级管理单位`, prop: `zdSubRespDeptCode`, type: `org`},
    { label: `二级分级管理单位姓名`, prop: `zdSubRespDeptUser` },
    { label: `二级分级管理单位手机`, prop: `zdSubRespDeptPhone` },
    { label: `二级分级管理单位邮箱`, prop: `zdSubRespDeptEmail` },

    { label: `是否央企/台资`, prop: `zdCenterCompany`, type: 'dict', dictKey: 'unipm_flag' },
    { label: `是否新基建项目`, prop: `zdNewBuildState`, type: 'dict', dictKey: 'unipm_flag' },
    { label: `是否两新一重`, prop: `zdTwoNewState`, type: 'dict', dictKey: 'unipm_flag' },
    { label: `省重点类别`, prop: `zdState`, type: 'dict', dictKey: 'unipmZdState' },

    { label: `省重点批次`, prop: `zdBatch`, type: 'dict', dictKey: 'unipmZdBatch' },
    { label: `上年度省重点类别`, prop: `zdLastYearState`, type: 'dict', dictKey: 'unipmZdLastYearState', disabled: true },
    // { label: `评审结果`, prop: `zdReviewState`, type: 'dict', dictKey: 'unipmZdReviewState' },
    { label: "至${theYearBeforeLast}年底累计完成投资（万元）", prop: `zdYearBeforeLastAmt`, type: 'number' },
    { label: "预计${lastYear}年当年完成投资（万元）", prop: `zdLastYearEstimateAmt`, type: 'number' },
    { label: `年度计划投资(万元)`, prop: `zdPlanAmt`, type: 'number' },
    { label: `省重点申报理由`, prop: `zdApplyMemo`, type: 'textarea' , span: 24},
    { label: `省重点备注1`, prop: `zdMemo2`, type: 'textarea' , span: 24},
    { label: `省重点备注2`, prop: `zdMemo3`, type: 'textarea' , span: 24},
    { label: `省重点需修改内容`, prop: `zdModify`, type: 'textarea' , span: 24 },
    { label: `省重点需修改内容已读状态`, prop: `zdModifyReadState`, type: 'dict', dictKey: 'unipm_flag' },
    { label: `至上年度完成情况`, prop: `zdLastYearDesc`, type: 'textarea' , span: 24 },
    { label: `本年工作目标`, prop: `zdPlanInfo`, type: 'textarea' , span: 24 },
    { label: `是否进行节能审查`, prop: `zdEnergyState` , type: 'dict', dictKey: 'unipm_flag' },
    { label: `节能审查批复文号`, prop: `zdEnergyFile` },
    { label: `设计年综合能耗（等价值）（万吨标准煤）`, prop: `zdEnergyDesign`, type: 'number' },
    { label: `“十四五”年新增能耗（万吨标准煤）`, prop: `zdEnergyAdd`, type: 'number' },
  ],
}

const yearRules = {
  zdIndustryCode: [
    {required: true, message: `省重点行业未选择`}
  ],
  zdRespDeptCode: [
    {required: true, message: `分级管理单位未选择`}
  ],
  zdSubRespDeptCode: [
    {required: true, message: `二级分级管理单位未选择`}
  ],
  zdRespDeptPhone: [
    {pattern: mobileReg, message: `分级管理单位手机格式不正确`, trigger: "blur" }
  ],
  zdRespDeptEmail: [
    { type: `email`, message: `分级管理单位邮箱格式不正确`, trigger: `blur` }
  ],
  zdSubRespDeptPhone: [
    {pattern: mobileReg, message: `二级分级管理单位手机格式不正确`, trigger: "blur" }
  ],
  zdSubRespDeptEmail: [
    { type: `email`, message: `二级分级管理单位邮箱格式不正确`, trigger: `blur` }
  ],
  zdItemIndustry: [
    {required: true, message: `产业类型未选择`}
  ],
  zdManageType: [
    {required: true, message: `管理类型未选择`}
  ],
  zdState: [{required: true, message: '省重点类别未选择'}],
  zdBatch: [{required: true, message: '省重点批次未选择'}],
  zdApplyMemo: [{required: true, message: '省重点申报理由未填写'}],
  zdPlanInfo: [{required: true, message: '本年工作目标未填写'}],
  zdLastYearDesc: [{required: true, message: '至上年度完成情况未填写'}],
  zdEnergyState: [{required: true, message: '是否进行节能审查未选择'}],
  zdEnergyFile: [{required: true, message: '节能审查批复文号未填写'}],
  zdEnergyDesign: [{required: true, message: '设计年综合能耗（等价值）（万吨标准煤）未填写'}],
  zdEnergyAdd: [{required: true, message: '“十四五”年新增能耗（万吨标准煤）未填写'}],
  zdYearBeforeLastAmt: [ 
    {required: true, message: "至${theYearBeforeLast}年底累计完成投资（万元）未填写"},
    {
      validator: '${focus}TotalAmtValidator', 
      messageTemplate: "至${theYearBeforeLast}年底累计完成投资（万元）+预计${lastYear}年当年完成投资（万元）+年度计划投资(万元)<=总投资", 
      trigger: "blur"
    }
  ],
  zdLastYearEstimateAmt: [ 
    {required: true, message: "预计${lastYear}年当年完成投资（万元）未填写"},
    
    {
      validator: '${focus}TotalAmtValidator', 
      messageTemplate: "至${theYearBeforeLast}年底累计完成投资（万元）+预计${lastYear}年当年完成投资（万元）+年度计划投资(万元)<=总投资", 
      trigger: "blur"
    }
  ],
  zdPlanAmt: [ 
    {required: true, message: "年度计划投资(万元)未填写"},
    {
      validator: '${focus}TotalAmtValidator', 
      messageTemplate: "至${theYearBeforeLast}年底累计完成投资（万元）+预计${lastYear}年当年完成投资（万元）+年度计划投资(万元)<=总投资", 
      trigger: "blur"
    }
  ],
}

/**
 * 获取属性
 * @returns 
 */
 const getLeafProps = () => {
  return yearConfig.children.map(({prop})=> prop);
}



/**
 * 获取省重点年计划表单配置
 * @param {*} themes 省重点专题
 * @returns 
 */
const getYearConfigGroup = (themes=[]) => {
  const years = getYears(themes);
  const yearConfigGroup =years.map(year=> {
    const variableObj = {
      theYearBeforeLast: Number(year) -2,
      lastYear: Number(year) -1
    }
    const _yearConfig ={};
    _yearConfig.title = `${year}${yearConfig.title}`;
    _yearConfig.themeState = THEME;
    _yearConfig.children = yearConfig.children.map(config=> {
       let label = labelReplace(config.label, variableObj);
      return {
        ...config,
        label,
        prop: getYearPropKey(THEME, year, config.prop)
      }
    })
    return _yearConfig;
  })
  return yearConfigGroup;
}
/**
 * 获取省重点年计划验证规则
 * @param {*} themes 
 * @returns 
 */
const getYearRules = (themes=[], options) => {
  const years = getYears(themes);
  let rules = {};
  years.forEach(year=> {
    const variableObj = {
      theYearBeforeLast: Number(year) -2,
      lastYear: Number(year) -1
    }
    Object.keys(yearRules).forEach(prop=> {
      rules[getYearPropKey(THEME, year, prop)] = yearRules[prop].map((rule)=>{
        if(rule.validator && typeof rule.validator === 'string') {
          return {...rule, validator: options?.validator && options?.validator[rule.validator], year}
        }
        return {...rule, message: labelReplace(rule.message, variableObj)}
      });
    })
  })
  return rules;
}

/**
 * 从表单中提取年计划列表
 * @param {*} form 
 * @param {*} themes 
 * @returns 
 */
export const getYearInfoList = (originalYearInfoList, form, themes=[]) => {
  const years = getYears(themes.filter(theme=> theme.startsWith(THEME)));
  // 表单对应的数据
  const yearInfoList = years.map(year=> {
    const yearInfo = {itemYear: year};
    const props = getLeafProps();
    props.forEach(prop=> {
      yearInfo[prop] = form[getYearPropKey(THEME, year, prop)]
    });
    return yearInfo;
  }).map(yearInfo=> {
    const finder = originalYearInfoList?.find(({itemYear})=> itemYear ===yearInfo.itemYear)
    return {
      ...finder,
      ...yearInfo
    }
  })
  //
  return yearInfoList
}

/**
 * 从年计划列表提取到表单属性中
 * @param {*} yearInfoList 
 */
 export const getYearFormFromYearInfoList = (yearInfoList) => {
  let yearForm = {};
  const props = getLeafProps();
  yearInfoList?.forEach(({itemYear, ...item}) => {
    props.forEach((prop)=>{
      yearForm[getYearPropKey(THEME, itemYear, prop)]= item[prop]
    })
  })
  return yearForm;
}

/**
 * 获取专题的配置
 * @param {*} themes 专题列表
 * @returns 
 */
const getThemeConfig = (themes =[], options) => {
  let _configGroup = [], _rules = {};
  const yearConfigGroup = getYearConfigGroup(themes);
  const yearRules = getYearRules(themes, options);
  _configGroup = [..._configGroup, ...yearConfigGroup];
  _rules = {..._rules, ...yearRules};
  return {
    configGroup: _configGroup,
    rules: _rules,
  }

}

/**
 * 业务 - 省重点行业改变， 关联 【产业类型: zdItemIndustry】 和 【产业分类: zdIndustryType】的值
 * 1. 当行业以SHSY开头的时候，产业类型是SHSY
 * 2. 当行业是以CXJSYSTHB,JT,NY开头的时候，产业类型是JCSS
 * 3. 当行业以GY开头且不为GY_GYYQJCSS时，产业类型是CYXM，产业分类是SECONDARY
 * 4. 当行业是GY_GYYQJCSS时，产业类型是JCSS
 * 5. 当行业以NLSL开头，且不为NLSL_LY，NLSL_XMY，NLSL_YY，NLSL_SG时，产业类型是CYXM，产业分类是PRIMARY
 * 6. 当行业以FWY开头，且不为FWY_FDC时，产业类型是CYXM，产业分类是TERTIARY
 * 7. 当行业不以SHSY开头，产业类型是JCSS
 * 以上条件都不符合，产业类型是SHSY
 * @param {*} zdIndustryCode 省重点行业编码
 */
export const zdIndustryCodeChangeBusiness = (zdIndustryCode)=> {
  let zdItemIndustry, zdIndustryType;
  if(zdIndustryCode) {
    if(zdIndustryCode.startsWith(`SHSY`)) {
      // 1
      zdItemIndustry = ZdItemIndustry.SHSY;
    } else if([`CXJSYSTHB`,`JT`,`NY`].some(key => zdIndustryCode.startsWith(key))) {
      // 2
      zdItemIndustry = ZdItemIndustry.JCSS
    } else if(zdIndustryCode.startsWith(`GY`) && zdIndustryCode !==`GY_GYYQJCSS`) {
      // 3
      zdItemIndustry = ZdItemIndustry.CYXM
      zdIndustryType = ZdIndustryType.SECONDARY
    } else if(zdIndustryCode ===`GY_GYYQJCSS`) {
      // 4
      zdItemIndustry = ZdItemIndustry.JCSS
    } else if(
      zdIndustryCode.startsWith(`NLSL`) && 
      ![`NLSL_LY`, `NLSL_XMY`, `NLSL_YY`, `NLSL_SG`].includes(zdIndustryCode)
    ) {
      // 5
      zdItemIndustry = ZdItemIndustry.CYXM
      zdIndustryType = ZdIndustryType.PRIMARY
    } else if(zdIndustryCode.startsWith(`FWY`) && zdIndustryCode !==`FWY_FDC` ) {
      // 6
      zdItemIndustry = ZdItemIndustry.CYXM
      zdIndustryType = ZdIndustryType.TERTIARY
    } else if(!zdIndustryCode.startsWith(`SHSY`)){
      // 7
      zdItemIndustry = ZdItemIndustry.JCSS
    } else {
      zdItemIndustry = ZdItemIndustry.SHSY;
    }
  }
  

  return {
    zdItemIndustry, zdIndustryType
  };
}



export default {
  getYearConfigGroup,
  getYearRules,
  getYearInfoList,
  getYearFormFromYearInfoList,
  getThemeConfig,
}