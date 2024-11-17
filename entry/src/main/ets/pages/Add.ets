import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import {AddEventButton} from '../components/AddEventButton'
import { CustomizedDatePicker } from '../components/CustomizedDatePicker';
import { InputBox } from '../components/InputBox';
import { SettingsButton } from '../components/SettingsButton';
import {CustomizedPicker} from '../components/CustomizedPicker'
import { OptionsPicker } from '../components/OptionsPicker';
import { CheckButton } from '../components/CheckButton';
import { ReturnButton } from '../components/ReturnButton';
import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

// 引入preferences相关
import { distributedKVStore } from '@kit.ArkData';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import KVStore from '../common/utils/KVStore';
import { KVStoreType } from '../viewmodel/KVStoreType';
import { OptionsPickerSymbol } from '../components/OptionsPickerSymbol';
import { SettingsModel } from '../model/SettingsModel';
import Settings from '../common/utils/SettingsHandler';


@Entry
@Component
struct Add {
        @State message: string = '';
        @State isDatePickerOpen: boolean = false;
        @State isTagOptionOpen: boolean = false;
        @State isRepeatOptionOpen: boolean = false;


        private tagOptions: Array<string> = ["生活", "工作", "生日", "爱情"];
        private repeatOptions: Array<string> = ["无重复", "每周重复", "每月重复", "每年重复"];
        @State titleValue: string = "";
        @State dateValue: Date = new Date(Date.now());
        @State repeatValue: string = this.repeatOptions[0];
        @State tagValue: string = this.tagOptions[0];
        @State topValue: boolean = false;

        private context = getContext(this) as common.UIAbilityContext;
        @State securityLevel: distributedKVStore.SecurityLevel = distributedKVStore.SecurityLevel.S1;
        @StorageLink('encrypted') encrypted: boolean = false;
        @StorageLink('kvStore') kvStore: KVStore | undefined = new KVStore(this.encrypted, this.securityLevel);
        @StorageLink('kvStoreAll') kvStoreAll: KVStoreType[] = [];
        private settings = new Settings();
        private settingsModel: SettingsModel = {
                background: "app.media.background1",
                remindTime: 0,
                format: 0
        };

        aboutToAppear(): void {
                let databaseDir = this.context.getApplicationContext().databaseDir;

                testNapi.initRDB(databaseDir);
                this.handlePreferencesExtract()
        }
        private async handlePreferencesExtract(){

                this.settingsModel =  await this.settings.getPreference()
        }

        private handleDateButtonClick(): void {
                this.isDatePickerOpen = true;
                this.isTagOptionOpen = false;
                this.isRepeatOptionOpen = false;
        }
        private handleTagButtonClick(): void{
                this.isDatePickerOpen = false;
                this.isTagOptionOpen = true;
                this.isRepeatOptionOpen = false;
        }
        private handleRepeatButtonClick(): void{
                this.isDatePickerOpen = false;
                this.isTagOptionOpen = false;
                this.isRepeatOptionOpen = true;
        }
        private handleTitleChange(value: string): void{
                this.titleValue = value;
        }
        private handleTopChange(value: boolean): void{
                this.topValue = value;
        }

        private handleDateChange(value: Date): void{

                this.dateValue = value
                console.log(this.dateValue.toDateString())
        }
        private handleTagChange(value: string): void{
                this.tagValue = value;
        }
        private handleRepeatChange(value: string): void{
                this.repeatValue = value;

        }

        private async handleDataSave(){
                let topValueString: string = this.topValue ? "true" : "false";

                testNapi.addRDB(this.titleValue, this.dateValue.toDateString(), this.repeatValue, this.tagValue, topValueString)

                let resultObjects = testNapi.searchRDB() as object[];


                for (let i: number = 0; i < resultObjects.length; i++) {

                        console.error(resultObjects[i]['title'] + " |  " + resultObjects[i]['date'] +"  |  " + resultObjects[i]['tag'] + "  |  " + resultObjects[i]['repeat'] + "  | " + resultObjects[i]['top'])
                }

        }


        build() {
                Row() {
                        Column() {

                                Column(){
                                        Row() {
                                                ReturnButton({url: "pages/Index"})

                                                Text("新增事件")
                                                        .fontSize(24)
                                                        .fontWeight(FontWeight.Bold)
                                                        .fontColor("#ffffff").width("40%")

                                                CheckButton({onButtonClick: {click: this.handleDataSave.bind(this)}})

                                        }.justifyContent(FlexAlign.SpaceBetween).width("95%")
                                        InputBox({
                                                title: "事件名",
                                                placeHolder: "testPlaceHolder",
                                                name: "title",
                                                type: "text",
                                                value: this.titleValue,
                                                onValueChange: {change: this.handleTitleChange.bind(this)}
                                        })

                                        CustomizedPicker({
                                                title: "日期",
                                                name: "date",
                                                type: "date",
                                                value: this.dateValue,
                                                onButtonClick: { click: this.handleDateButtonClick.bind(this) }
                                        })

                                        CustomizedPicker({
                                                title: "分类",
                                                name: "tag",
                                                type: "tag",
                                                value: this.tagValue,
                                                onButtonClick: { click: this.handleTagButtonClick.bind(this) },
                                                options: this.tagOptions
                                        })
                                        CustomizedPicker({
                                                title: "重复",
                                                name: "repeat",
                                                type: "repeat",
                                                value: this.repeatValue,
                                                onButtonClick: { click: this.handleRepeatButtonClick.bind(this) },
                                                options: this.repeatOptions
                                        })
                                        InputBox({
                                                title: "置顶",
                                                name: "top",
                                                type: "switch",
                                                value: this.topValue,
                                                onValueChange: {change: this.handleTopChange.bind(this)}
                                        })


                                }


                                Column(){
                                        if (this.isDatePickerOpen) {
                                                CustomizedDatePicker({
                                                        date: this.dateValue,
                                                        onButtonClick: { click: this.handleDateChange.bind(this) }
                                                });
                                        }

                                        if (this.isTagOptionOpen) {
                                                OptionsPicker({
                                                        name: "tagOptions",
                                                        options: this.tagOptions,
                                                        onButtonClick: { click: this.handleTagChange.bind(this) }
                                                })
                                        }

                                        if (this.isRepeatOptionOpen) {
                                                OptionsPicker({
                                                        name: "repeatOptions",
                                                        options: this.repeatOptions,
                                                        onButtonClick: { click: this.handleRepeatChange.bind(this) }
                                                })
                                        }
                                }



                        }.width('100%').justifyContent(FlexAlign.SpaceBetween).height("95%")

                }
                .height('100%').backgroundImage($r(this.settingsModel.background)).backgroundImageSize(ImageSize.Cover)
        }
}
