import { RequestUtil } from "@newboss/nb-common";
export const getItemIndustryChart = (params) => {
  return RequestUtil.get(`/unipm-api/unipm/itemFocus/indexManage/getZdItemIndustryReport`, {
      params
  });
}
export default {
  getItemIndustryChart
}