import { LightningElement, wire } from "lwc";
import getAccounts from "@salesforce/apex/DevOpsAccountService.getAccounts";

export default class DevOpsAccountPanel extends LightningElement {
  @wire(getAccounts, { accountName: "" })
  accounts;
}
