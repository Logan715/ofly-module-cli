<template>
  <div>
    <el-row v-loading="loading" :gutter="24">
      <el-col :span="24">
        <nb-search-bar
          :init-data="initCondition"
          :items="searchItems"
          :height.sync="searchHeight"
          @search="handleSearch"
        >
          <template #tagCode="{ form }">
            <ItemTagListSelect v-model="form.tagCode" :theme="THEME" />
          </template>
        </nb-search-bar>
      </el-col>
      <el-col :span="24">
        <nb-bz-table
          selection
          :height="`100vh - ${searchHeight}px`"
          :columns="columns"
          :data="list"
          :pagination="pagination"
          @pagination-change="handlePaginationChange"
          @row-dblclick="handleEdit"
          @selection-change="handleSelectionChange"
        >
          <template #toolbar_right>
            <${KeyItemProvince}ToolBarOperation
              :tag-code="condition.tagCode || tagCode"
              :select-rows="selectRows"
              :condition="condition"
              @handle-finished="loadData"
            />

          </template>
          <el-button
            slot="itemName"
            slot-scope="{ row }"
            class="link"
            type="text"
            @click="handleEdit(row)"
          >
            {{ row.itemName }}
          </el-button>
          <template #handle="{ row }">
            <${KeyItemProvince}RowOperation 
              :data="row" 
              :menu-func-list="menuFuncList"
              @handle-operation="handleOperation"
            />
          </template>
        </nb-bz-table>
      </el-col>
    </el-row>
    <${KeyItemProvince}EditModal
      :visible.sync="visible"
      :item-id="editRow.itemId"
      :item-tag-id="editRow.itemTagId"
      :tag-code="condition.tagCode"
      @handle-finished="loadData"
    />
    <BaseItemAvaiableModifyModal
      :visible.sync="modifyVisible"
      :item-id="editRow.itemId"
      :item-tag-id="editRow.itemTagId"
      :tag-code="THEME"
      @handle-save="handleModifySave"
      @handle-submit="handleModifySubmit"
    />

    <${KeyItemProvince}ReviewListModal
      :visible.sync="reviewVisible"
      :item-id="editRow.itemId"
      :item-tag-id="editRow.itemTagId"
    />
  </div>
</template>

<script>

import { getSearchItems, getColumns, RowOperation } from "./config";
import PaginationUtil from "@/utils/PaginationUtil";
import ${KeyItemProvince}EditModal from "./views/${KeyItemProvince}EditModal.vue";
import ${KeyItemProvince}ReviewListModal from "../${KeyItemProvince}Review/${KeyItemProvince}ReviewListModal.vue";
import BaseItemAvaiableModifyModal from "@/modules/BaseItem/BaseItemAvailable/BaseItemAvaiableModify/BaseItemAvaiableModifyModal.vue";
import { getListPage, del } from "../api";
import { 
  THEME, 
 } from "../core/index";
import moment from 'moment';

import ItemTagListSelect from '@/modules/ItemTag/ItemTagSelect/ItemTagListSelect.vue'
import ${KeyItemProvince}RowOperation from './views/${KeyItemProvince}RowOperation.vue'
import ${KeyItemProvince}ToolBarOperation from './views/${KeyItemProvince}ToolBarOperation.vue';
import { existFunction } from '@/utils/MenuUtil'
import {MENU_FUNC} from '@/modules/Theme/${KeyItemProvince}/core/index'
export default {
  components: {
    ${KeyItemProvince}RowOperation,
    ${KeyItemProvince}ToolBarOperation,
    ${KeyItemProvince}EditModal,
    BaseItemAvaiableModifyModal,
    ${KeyItemProvince}ReviewListModal,
    ItemTagListSelect,
  },
  props: {
    menuId: String,
    menuFuncList: {
      type: Array,
      default:()=> []
    },
    multipleYear: {
      type: Boolean,
      default: true,
    },
    year: {
      type: String,
      default: `${moment().year()}`
    },
  },
  data() {
    let tagCode, initCondition={};
    if(this.multipleYear) {
      initCondition = {tagCode: `${THEME}${this.year}`}
    } else {
      tagCode = `${THEME}${this.year}`
    }
    const showReviewState = existFunction(this.menuFuncList, MENU_FUNC.SHOW_REVIEW_STATE);
    return {
      THEME,
      tagCode,
      loading: false,
      searchItems: getSearchItems(this.multipleYear, showReviewState),
      searchHeight: undefined,
      initCondition,
      condition: {},
      columns: getColumns(showReviewState),
      list: [],
      pagination: PaginationUtil.initPagination(),
      visible: false, // 编辑
      editRow: {},
      selectRows: [],
      modifyVisible: false, // 变更
      quitVisible:false, // 退库
      reviewVisible: false // 评审
    };
  },
  watch: {
    visible(val) {
      if (!val) {
        this.editRow = {};
      }
    },
  },
  created() {
    this.handleSearch(this.initCondition);
  },
  methods: {
    async loadData(condition = this.condition, pagination = this.pagination) {
      this.loading = true;
      try {
        const { list, total } = await getListPage(
          this.multipleYear? 
             condition:
            {...condition, tagCode: this.tagCode}
          , pagination);
        this.condition = condition;
        this.list = list;
        this.pagination = { ...pagination, total };
      } catch (e) {
        console.error(e);
      }
      this.loading = false;
    },
    async del(itemTagId) {
      this.loading = true;
      try {
        await del(itemTagId);
        this.$message.success("删除成功");
        setTimeout(this.loadData, 50);
      } catch (e) {
        console.error(e);
      }
      this.loading = false;
    },
    handleTagChange(tagCode) {
      this.tagCode = tagCode;
    },
    handleSearch(condition) {
      this.loadData(condition, PaginationUtil.initPagination());
    },
    handlePaginationChange(pagination) {
      this.loadData(undefined, pagination);
    },
    handleEdit(row = {}) {
      this.editRow = row;
      this.visible = true;
    },
    handleModify(row = {}) {
      this.editRow = row;
      this.modifyVisible = true;
    },
     handleQuit(row = {}) {
      this.editRow = row;
      this.quitVisible = true;
    },
    handleReview(row={}) {
      this.editRow = row;
      this.reviewVisible = true;
    },
    handleDelete(row) {
      this.del(row.itemTagId)
    },
    handleSelectionChange(rows) {
      this.selectRows = rows;
    },

    handleModifySave(form) {
      alert("变更保存");
    },
    handleModifySubmit(form) {
      alert("变更提交");
    },
    handleOperation(rowOperation, row) {
      switch(rowOperation) {
        case RowOperation.EDIT:
          this.handleEdit(row);
          break;
        case RowOperation.SUSPENSION:
          this.handleQuit(row);
          break;
        case RowOperation.REVIEW: 
          this.handleReview(row);
          break;
        case RowOperation.DELETE:
          this.handleDelete(row);
          break;
        default: 
          throw new Error(`没有该【${rowOperation}】操作`)
      }
    }
  },
};
</script>
<style lang="less" scoped>
.link {
  width: 100%;
  text-align: left;
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
  font-size: 14px;
}
</style>
