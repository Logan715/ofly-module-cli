import { getYears, getYearPropKey, removeProps, addProps, labelReplace } from '@/utils/FormUtil'
import { THEME } from '..';
import { zdIndustryCodeChangeBusiness } from '../item'
export default {
  data () {
    return {
      ${focus}HiddenProps: [], 
      ${focus}NotRequiredProps: [],
      ${focus}YearWatchs: [],
      ${focus}Validator: {
        ${focus}TotalAmtValidator: this.${focus}TotalAmtValidator
      }
    }
  },
  watch: {
    tagsCode: {
      immediate: true,
      handler(val) {
        this.${focus}YearWatchs?.forEach(yearWatch=>yearWatch());
        this.${focus}YearWatchs = [];
        const years = getYears(val?.filter(tagCode=>tagCode?.startsWith(THEME)));
        years.forEach(year=> {
          const unZdStateWatch = this.$watch(
            `item.${getYearPropKey(THEME, year, "zdState")}`, 
            (newVal)=> this.${focus}ZdState(year, newVal)
        , {immediate:true})
        const unZdIndustryCodeWatch = this.$watch(
          `item.${getYearPropKey(THEME, year, "zdIndustryCode")}`, 
          (newVal)=> this.zdIndustryCodeChange(year, newVal)
      , {immediate:true})
          this.${focus}YearWatchs.push(unZdStateWatch)
          this.${focus}YearWatchs.push(unZdIndustryCodeWatch)
        })
      }
    },
    "item.zdIndustryCode"(val) {
      const { zdItemIndustry, zdIndustryType } = zdIndustryCodeChangeBusiness(val);
      this.item.zdItemIndustry = zdItemIndustry
      this.item.zdIndustryType = zdIndustryType;
    },
  },
  methods: {
    zdIndustryCodeChange(year, newVal) {
      const { zdItemIndustry, zdIndustryType } = zdIndustryCodeChangeBusiness(newVal);
      this.item[getYearPropKey(THEME, year, "zdItemIndustry")] = zdItemIndustry
      this.item[getYearPropKey(THEME, year, "zdIndustryType")] = zdIndustryType;
    },
    ${focus}ZdState(year, newVal) {
      if(newVal === `CZGL`) {
        removeProps(this.${focus}HiddenProps, [getYearPropKey(THEME, year, "zdBatch")])
      } else {
        addProps(this.${focus}HiddenProps, [getYearPropKey(THEME, year, "zdBatch")])
      }
    },
    ${focus}TotalAmtValidator(rule, value, callback) {
      const { messageTemplate, year } = rule;
      const zdYearBeforeLastAmt = Number(this.item[getYearPropKey(THEME, year, 'zdYearBeforeLastAmt')] || 0);
      const zdLastYearEstimateAmt = Number(this.item[getYearPropKey(THEME, year, 'zdLastYearEstimateAmt')]|| 0) ;
      const zdPlanAmt = Number(this.item[getYearPropKey(THEME, year, 'zdPlanAmt')]|| 0);
      if(this.item.totalAmt < (
        zdYearBeforeLastAmt + zdLastYearEstimateAmt + zdPlanAmt
      )) {
        const variableObject = {
          theYearBeforeLast: Number(year) -2,
          lastYear: Number(year) - 1
        }
        const _message = labelReplace(messageTemplate, variableObject);
        return callback(new Error(_message))
      }
      callback()
    }
  }
}