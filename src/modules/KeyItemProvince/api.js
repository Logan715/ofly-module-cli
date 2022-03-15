import { RequestUtil, ConfigKey, ConfigUtil, UrlUtil } from '@newboss/nb-common'
export const getListPage = (params, {size, page}) => {
  return RequestUtil.get(`/unipm-api/unipm/itemFocus/getPage`, {params:{...params, page, size}})
}
export const tempSave = (form) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/tempSave`, form)
}
export const save = (form) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/update`, form)
}
export const del = (itemTagId) => {
  return RequestUtil.get(`/unipm-api/unipm/itemFocus/deleteById`, {params:{itemTagId}})
}
export const submit = (form) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/submit`, form)
}
export const batchSubmit = (itemTagIdList) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/batchSubmit`, itemTagIdList)
}
export const withdraw = (id) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/batchWithdraw`, [id])
}
export const batchWithdraw = (itemTagIdList) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/batchWithdraw`, itemTagIdList)
}
export const getTodoAuditListPage = (params, {size, page}) => {
  return RequestUtil.get(`/unipm-api/unipm/itemFocus/getTodoAuditPage`, {params:{...params, page, size}})
}
export const audit = ({type, comment, ...other}) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/audit`, {
    doFlowType: type, comment, ...other
  })
}
export const batchAudit = ({type, comment, itemTagIdList}) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/batchAudit`, {
    doFlowType: type, comment, itemTagIdList
  })
}

export const getExportExcelAllowId = (params, columnList)=> {
  return RequestUtil.post(
    `/unipm-api/unipm/itemFocus/getExportExcelAllowId`, 
    { ...params, columnList })
}

export const getExportColumns = (tagCode) => {
  return RequestUtil.get(
    `/unipm-api/unipm/itemFocus/getExportDict`, 
    { params: {tagCode} }).then(data=> {
 
      return data.map(
        ({dictDataCode, dictDataName})=>
        ({value: dictDataCode, label: dictDataName})
      )
    })
  
}

export const downloadUrlBySelectColumns = (allowId)=> {
  const menuId = ConfigUtil.getConfig(ConfigKey.MEMU_ID);
  const tenantId = ConfigUtil.getConfig(ConfigKey.TENANT_ID);
  return UrlUtil.get(`/unipm-api/unipm/itemFocus/exportExcel?allowId=${allowId}&sysMenuId=${menuId}&sysTenantId=${tenantId}`)
}


export const getItem = (id, itemTagId) => RequestUtil.get(`/unipm-api/unipm/itemFocus/getById`, { params: { id, itemTagId } })

export const getBackItem = (itemBackId) => RequestUtil.get(`/unipm-api/unipm/itemFocus/itemBack/getById`, {params: {itemBackId: itemBackId }})


/************************调度上报***********************************/
export const getScheduleListPage = (params, {size, page}) => {
  return RequestUtil.get(`/unipm-api/unipm/scheduleFocus/getPage`, {params:{...params, page, size}})
}
export const scheduleTempSave = (form) => {
  return RequestUtil.post(`/unipm-api/unipm/scheduleFocus/tempSave`, form)
}
export const scheduleSave = (form) => {
  return RequestUtil.post(`/unipm-api/unipm/scheduleFocus/update`, form, {headers: {__catch: false}})
}
export const scheduleSubmit = (form) => {
  return RequestUtil.post(`/unipm-api/unipm/scheduleFocus/submit`, form, {headers: {__catch: false}})
}
export const scheduleBatchSubmit = (scheduleIdList) => {
  return RequestUtil.post(`/unipm-api/unipm/scheduleFocus/batchSubmit`, scheduleIdList)
}
export const scheduleWithdraw = (itemTagId, scheduleId) => {
  return RequestUtil.post(`/unipm-api/unipm/scheduleFocus/batchWithdraw`, [{itemTagId, scheduleId}])
}
export const scheduleBatchWithdraw = (scheduleIdList) => {
  return RequestUtil.post(`/unipm-api/unipm/scheduleFocus/batchWithdraw`, scheduleIdList)
}
export const getScheduleTodoAuditListPage = (params, {size, page}) => {
  return RequestUtil.get(`/unipm-api/unipm/scheduleFocus/getTodoAuditPage`, {params:{...params, page, size}})
}
export const scheduleAudit = ({type, comment, ...other}) => {
  return RequestUtil.post(`/unipm-api/unipm/scheduleFocus/audit`, {
    doFlowType: type, comment, ...other
  })
}
export const scheduleBatchAudit = ({type, comment, scheduleIdList}) => {
  return RequestUtil.post(`/unipm-api/unipm/scheduleFocus/batchAudit`, {
    doFlowType: type, comment, scheduleIdList
  })
}
export const getSchedule = (itemTagId, scheduleId, scheduleDate) => RequestUtil.get(`/unipm-api/unipm/scheduleFocus/getById`, {params: {itemTagId, id: scheduleId, scheduleDate}})


export const getScheduleExportExcelAllowId = (params, columnList)=> {
  return RequestUtil.post(
    `/unipm-api/unipm/scheduleFocus/getExportExcelAllowId`, 
    { ...params, columnList })
}

export const getScheduleExportColumns = (tagCode) => {
  return RequestUtil.get(
    `/unipm-api/unipm/scheduleFocus/getExportDict`, 
    { params: {tagCode} }).then(data=> {
      return data.map(
        ({dictDataCode, dictDataName})=>
        ({value: dictDataCode, label: dictDataName})
      )
    })
  
}

export const downloadScheduleUrlBySelectColumns = (allowId)=> {
  const menuId = ConfigUtil.getConfig(ConfigKey.MEMU_ID);
  const tenantId = ConfigUtil.getConfig(ConfigKey.TENANT_ID);
  return UrlUtil.get(`/unipm-api/unipm/scheduleFocus/exportExcel?allowId=${allowId}&sysMenuId=${menuId}&sysTenantId=${tenantId}`)
}

export const getScheduleCompareAllowId = (params)=> {
  return RequestUtil.get(
    `/unipm-api/unipm/scheduleFocus/getExportCompareExcelAllowId`, 
    {params}
    )
}

export const getScheduleCompareUrl = (allowId) => {
  const menuId = ConfigUtil.getConfig(ConfigKey.MEMU_ID);
  const tenantId = ConfigUtil.getConfig(ConfigKey.TENANT_ID);
  return UrlUtil.get(`/unipm-api/unipm/scheduleFocus/exportCompareExcel?allowId=${allowId}&sysMenuId=${menuId}&sysTenantId=${tenantId}`)
}




/************************ 项目退库 ***********************************/

/**
 * 查询退库列表
 * @param {*} params 查询条件
 * @param {*} param1 
 * @returns 
 */
export const getSusPensionListPage = (params, {size, page}) => {
  return RequestUtil.get(`/unipm-api/unipm/itemFocus/itemBack/itemBackGetPage`, {params:{...params, page, size}})
}
// 省重点项目库-根据Id删除项目退库表
export const deleteItemBackById = (params) => {
  return RequestUtil.get(`/unipm-api/unipm/itemFocus/itemBack/deleteItemBackById`, {params:params})
}
/**
 * 获取退库信息
 * @param {*} itemBackId 退库ID
 * @returns 
 */
export const getSuspension = (itemBackId) => {
  return RequestUtil.get(`/unipm-api/unipm/itemFocus/itemBack/getByItemBackId`, {params: {itemBackId}})
}
/**
 * 项目退库 - 审核
 * @param {*} param0 
 * @returns 
 */
export const suspensionAudit = (params) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/itemBack/itemBackAudit`, params)
}

// 省重点项目库-项目退库批量审核
export const itemBackBatchAudit = (params) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/itemBack/itemBackBatchAudit`, params)
}

// 省重点项目库-项目退库批量提交
export const itemBackBatchSubmit = (itemBackIds) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/itemBack/itemBackBatchSubmit`, itemBackIds)
}

// 省重点项目库-项目退库批量撤回项目
export const itemBackBatchWithdraw = (itemBackIds) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/itemBack/itemBackBatchWithdraw`, itemBackIds)
}

// 省重点项目库-项目退库提交
export const itemBackSubmit = (form) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/itemBack/itemBackSubmit`, form)
}

// 省重点项目库-项目退库撤回
export const itemBackWithdraw = (form) => {
  return RequestUtil.post(`/unipm-api/unipm/itemFocus/itemBack/itemBackWithdraw`, form)
}

// components



