<template>
  <nb-scroll-tabs-dialog
    ref="editDialogRef"
    v-loading="loading"
    :value="visible"
    title="省重点项目"
    :active-tab.sync="activeTab"
    :tabs="tabs"
    @close="close"
  >
    <template #baseInfo>
      <ItemForm 
        v-if="visible" 
        ref="form" 
        v-model="item" 
        :theme="theme"
        :tags-code="tagCode?[tagCode]:[]" 
        :item-pre-work.sync="itemPreWork"
        :investment.sync="investment"
        :readonly="readonly" 
        @amt-update="jump2Investment"
        @upload-success="handleUploadSuccess"
      />
    </template>
    <template #preWork>
      <PreWorkList
        v-model="itemPreWork"
        :item-id="businessId"
        :readonly="readonly"
        @attachment-change="handleUploadSuccess"
      />
    </template>
    <template #investment>
      <InvestmentList
        v-if="visible"
        v-model="investment"
        :item-id="item.itemId"
        :invest-id="item.ysInvestDirectId"
        :readonly="readonly"
      />
    </template>
    <template #map>
      <BaseItemMap :item-id="item.itemId" :readonly="readonly" />
    </template>
    <template #itemFiles>
      <ItemFiles ref="itemFilesRef" :item-id="businessId" />
    </template>
    <template #flow>
      <nb-workflow-view :flow-id="item.tagWfFlowId" />
    </template>
    <template #footer>
      <el-button @click="close">取消</el-button>
      <el-button v-if="auth.canTempSave" type="primary" @click="handleTempSave">
        暂存
      </el-button>
      <el-button v-if="auth.canSave" type="primary" @click="handleSave">
        保存
      </el-button>
      <el-button v-if="auth.canSubmit" type="primary" @click="handleSubmit">
        提交
      </el-button>
      <el-button v-if="auth.canWithdraw" type="primary" @click="handleWithdraw">
        撤回
      </el-button>
    </template>
  </nb-scroll-tabs-dialog>
</template>
<script>
import InvestmentList from "@/modules/components/InvestmentList/index.vue";
import PreWorkList from "@/modules/components/PreWorkList/index.vue";
import ItemFiles from "@/modules/components/ItemFiles/index.vue"
import BaseItemMap from "@/modules/BaseItem/BaseItem/views/BaseItemMap.vue";
import FormUtil from "@/utils/FormUtil";
import {getYearInfoList, getYearFormFromYearInfoList } from "@/modules/Theme/KeyItemProvince/core/item";
import { THEME } from "@/modules/Theme/KeyItemProvince/core/index";
import {
  tempSave,
  save,
  submit,
  withdraw,
  getItem,
} from "../../api";
import ItemForm from '@/modules/BaseItem/core/ItemForm/index.vue'
export default {
  components: {
    InvestmentList,
    PreWorkList,
    ItemFiles,
    BaseItemMap,
    ItemForm
  },
  props: {
    visible: Boolean,
    itemId: {
      type: String,
      default: "",
    },
    itemTagId: {
      type: String,
      default: "",
    },

  },
  data() {
    return {
      theme: THEME,
      configGroup: undefined,
      rules: {},
      activeTab: "baseInfo",
      loading: false,
      auth: { canTempSave: true, canSubmit: true },
      tagCode: undefined,
      item: {},
      itemPreWork: [],
      itemPerforIndex: [],
      investment: {},
      tagsCode: [],
      zdYearInfo: [],
    };
  },
  computed: {
    tabs() {
      return [
        { label: "基本信息", name: "baseInfo" },
        { label: "前期工作", name: "preWork" },
        { label: "投资情况", name: "investment" },
        { label: "项目地图", name: "map" },
        { label: "项目档案", name: "itemFiles" },
        { label: "审核记录", name: "flow", show: this.item.tagWfFlowId },
      ];
    },
    formData() {
      return {
        item: this.item,
        itemPreWork: this.itemPreWork,
        ...this.investment,
        zdYearInfo: getYearInfoList(this.zdYearInfo, this.item, [
          this.tagCode,
        ]),
      };
    },
    businessId() {
      return this.item.itemId;
    },
    readonly() {
      return this.itemId && !this.auth.canTempSave && !this.auth.canSubmit;
    },
  },
  watch: {
    visible: {
      immediate: true,
      handler(val) {
        if (val && this.itemId) {
          this.loadData();
        } else {
          this.auth = { canTempSave: true, canSubmit: true };
        }
        if (!val) {
          this.reset();
        }
      },
    }
  },
  methods: {
    async loadData() {
      this.loading = true;
      try {
        const { auth, item, tagCode, zdYearInfo } = await getItem(this.itemId, this.itemTagId);
        this.auth = auth;
        const focusYearForm = getYearFormFromYearInfoList(zdYearInfo);
        this.zdYearInfo = zdYearInfo;
        this.tagCode = tagCode;
        this.item = { ...item, ...focusYearForm };
      } catch (e) {
        console.error(e);
      }
      this.loading = false;
    },
    async tempSave() {
      this.loading = true;
      try {
        await tempSave(this.formData);
        this.$message.success("暂存成功");
        this.$emit("update:visible", false);
        this.$emit("handle-finished");
      } catch (e) {
        console.error(e);
      }
      this.loading = false;
    },
    async submit() {
      this.loading = true;
      try {
        await submit(this.formData);
        this.$message.success("提交成功");
        this.$emit("update:visible", false);
        this.$emit("handle-finished");
      } catch (e) {
        console.error();
      }
      this.loading = false;
    },
    async save() {
      this.loading = true;
      try {
        await save(this.formData);
        this.$message.success("提交成功");
        this.$emit("update:visible", false);
        this.$emit("handle-finished");
      } catch (e) {
        console.error();
      }
      this.loading = false;
    },
    async withdraw() {
      this.loading = true;
      try {
        await withdraw(this.item.itemTagId);
        this.$message.success("撤回成功");
        this.$emit("update:visible", false);
        this.$emit("handle-finished");
      } catch (e) {
        console.error();
      }
      this.loading = false;
    },
    handleTempSave() {
      this.tempSave();
    },
    handleSubmit() {
      this.$refs.form.validate((validate, errors) => {
        if (validate) {
          this.submit();
        } else {
          FormUtil.errorScroll(errors);
        }
      });
    },
    handleSave() {
      this.$refs.form.validate((validate, errors) => {
        if (validate) {
          this.save();
        } else {
          FormUtil.errorScroll(errors);
        }
      });
    },
    handleWithdraw() {
      this.withdraw();
    },
    jump2Investment() {
      this.$refs.editDialogRef.handleTabClick({name: "investment"})
    },
    handleUploadSuccess() {
      this.$refs.itemFilesRef?.refresh();
    },
    handleSyncData({ item, preWorkList }) {
      this.item = {
        ...this.item,
        ...item,
      };
      const _preWorkList = this.itemPreWork.map((preWork) => {
        const finder = preWorkList.find(
          ({ checkMatter }) => checkMatter === preWork.checkMatter
        );
        return finder || preWork;
      });
      this.itemPreWork = _preWorkList;
    },
    reset() {
      this.tagCode = undefined;
      this.activeTab = "baseInfo";
      this.auth = { canTempSave: true, canSubmit: true };
      this.item = {};
      this.itemPreWork = [];
      this.itemPerforIndex = [];
      this.investment = {};
      this.tagsCode = [];
      this.zdYearInfo = [];
    },
    close() {
      this.$emit("update:visible", false);
    },
  },
};
</script>
