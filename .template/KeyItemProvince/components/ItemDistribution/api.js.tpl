import { RequestUtil } from "@newboss/nb-common";
export const getItemCityReport = (params) => {
  return RequestUtil.get(`/unipm-api/unipm/${itemFocus}/indexManage/getLocaleCodeReport`, {
      params
  });
}


export const getOverviewAttribute = (params) => {
  return RequestUtil.get(`/unipm-api/unipm/${itemFocus}/indexManage/getOverviewReport`, {
      params
  });
}

export default {
  getItemCityReport,
  getOverviewAttribute
}