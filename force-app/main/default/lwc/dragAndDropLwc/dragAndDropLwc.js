import { LightningElement, wire, track } from 'lwc';
import getOpportunities from'@salesforce/apex/kanbanview.getOpportunities';
import { getListUi } from 'lightning/uiListApi';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
import ID_FIELD from '@salesforce/schema/Opportunity.Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DragAndDropLwc extends LightningElement {
    records;
    pickVals;
    recordId;
@wire (getOpportunities) 
    wiredListView({ error, data }) {
        if (data) {
            console.log("getListUi", data);
            this.records = data.map(item => {
               // let field = item.fields;
                //let account = field.Account.value.fields;
                return item;
            });
            console.log(this.records)
        }
        if (error) {
            console.error(error);
        }
    }
    

    /** Fetch metadata about the opportunity object**/
    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
    objectInfo;
    
    	@wire(getPicklistValues,{ recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: STAGE_FIELD})
    stagePicklistValues({ data, error }) {
        if (data) {
            console.log("Stage Picklist", data);
            this.pickVals = data.values.map(item => item.value);
        }
        if (error) {
            console.error(error);
        }
    }


    /****getter to calculate the  width dynamically*/
   get calcWidth(){
        let len = this.pickVals.length +1
        return `width: calc(100vw/ ${len})`
    }

    handleListItemDrag(event){
        this.recordId = event.detail
    }

    handleItemDrop(event){
        let stage = event.detail
        // this.records = this.records.map(item=>{
        //     return item.Id === this.recordId ? {...item, StageName:stage}:{...item}
        // })
        this.updateHandler(stage)
    }
    updateHandler(stage){
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[STAGE_FIELD.fieldApiName] = stage;
        const recordInput ={fields}
        updateRecord(recordInput)
        .then(()=>{
            console.log("Updated Successfully");
            this.showToast()
            return refreshApex(this.wiredListView)
        }).catch(error=>{
            console.error(error);
        })
    }

    showToast(){
        this.dispatchEvent(
            new ShowToastEvent({
                title:'Success',
                message:'Stage updated Successfully',
                variant:'success'
            })
        )
    }
}