import { RequestUtil } from "@newboss/nb-common";
export const getItemProfessionProportionList = (params) => {
  return RequestUtil.get(`/unipm-api/unipm/itemFocus/indexManage/getZdIndustryCodeReport`, {
      params
  });
}
export default {
  getItemProfessionProportionList
}