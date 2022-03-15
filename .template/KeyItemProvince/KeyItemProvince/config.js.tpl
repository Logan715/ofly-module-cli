
import { 
  MenuFunction, 
  ToolBarOperation as CommonToolBarOperation
} from '@/modules/constant'
import { getColumns as getColumnsByProps } from '@/modules/Theme/${KeyItemProvince}/core/index';
import { getSearchItems as getCommonSearchItems, tagCodeSearchItem }  from '@/modules/Theme/${KeyItemProvince}/core/item';

export const getColumns = (showReviewState)=> {
  let _columns = getColumnsByProps(
    [
      "tagWfCurState",
      "itemName",
      "itemCode",
      "zdLastYearState",
      "zdState",
      "zdIndustryCode",
      "zdRespDeptCode",
      "totalAmt",
      "localeCode",
      "zdItemIndustry",
      "startState",
      "endState",
      "zdReviewState",
      {label: '操作', prop: 'handle', fixed: 'right', width: 110},
    ]);
    if(!showReviewState) {
      _columns = _columns.filter(item=> item.prop !== `zdReviewState`)
    }
    return _columns;
}

		
export const getSearchItems = (multipleYear, showReviewState) => {
  let _searchItems = getCommonSearchItems();
  multipleYear && _searchItems.unshift(tagCodeSearchItem);
  if(!showReviewState) {
    _searchItems = _searchItems.filter(item=> item.prop !== `zdReviewState`)
  }
  return _searchItems;
}

export const RowOperation = {
  /** 编辑 */
  EDIT: 'edit',
  /** 退库 */
  SUSPENSION: MenuFunction.ITEM_SUSPENSION,
  /** 删除 */
  DELETE: 'delete',
  /** 评审 */
  REVIEW: 'review',
}

export const ToolBarOperation = {
  /** 从储备库挑选项目 */
  SELECT_FROM_BASE: CommonToolBarOperation.SELECT_FROM_BASE,
  /** 选列导出 */
  EXPORT_SELECT_COLUMN: CommonToolBarOperation.EXPORT_SELECT_COLUMN,
  /** 批量提交 */
  BATCH_SUBMIT: CommonToolBarOperation.BATCH_SUBMIT,
  /** 批量撤回 */
  BATCH_WITHDRAW: CommonToolBarOperation.BATCH_WITHDRAW,
  /** 批量续列 */
  BATCH_CONTINUE: 'batchContinue',
  /** 批量不续列 */
  BATCH_NOT_CONTINUE: 'batchNotContinue'
}

export default {
  getSearchItems,
}