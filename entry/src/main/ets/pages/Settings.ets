import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import {AddEventButton} from '../components/AddEventButton'
import { CustomizedDatePicker } from '../components/CustomizedDatePicker';
import { InputBox } from '../components/InputBox';
import { SettingsButton } from '../components/SettingsButton';
import {CustomizedPicker} from '../components/CustomizedPicker'
import { OptionsPicker } from '../components/OptionsPicker';
import { ReturnButton } from '../components/ReturnButton';
import router from '@ohos.router';
import { SettingsModel } from '../model/SettingsModel';
import SettingsHandler from '../common/utils/SettingsHandler';
import resourceManager from '@ohos.resourceManager'
import { ReminderHandler } from '../common/utils/ReminderHandler';
import { common, contextConstant } from '@kit.AbilityKit';
import { EventItem } from '../model/EventModel';
import { inputMethod } from '@kit.IMEKit';


@Entry
@Component
struct Settings {
        @State message: string = '';
        @State emptyValue: string = ""
        @State settings: SettingsHandler = new SettingsHandler();
        @State settingsModel: SettingsModel = {
                background: "app.media.background1",
                remindTime: 0,
                format: 0
        };
        @State optionsRemind: string[] = [

        ]
        @State valueRemind: string = ""
        @State isRemindOpen: boolean = false
        @State optionsFormat: string[] = [
                "年-月-日",
                "月-日-年",
                "日-月-年"

        ]
        @State valueFormat: string = ""
        @State isFormatOpen: boolean = false
        @State customizedBackground: PixelMap | ResourceStr | undefined = undefined
        private reminderHandler: ReminderHandler = new ReminderHandler();
        private context = getContext(this) as common.UIAbilityContext;
        @State eventList: EventItem[] = [];

        aboutToAppear(): void {



                this.handlePreferencesExtract()
                for(let i = 0; i < 24; i++){
                        let tempStr: string = (i).toString()
                        if(i < 10){
                                tempStr = "0" + tempStr
                        }
                        tempStr = tempStr + ":00"
                        this.optionsRemind.push(tempStr)
                }



                this.context.area = contextConstant.AreaMode.EL2
                let databaseDir = this.context.getApplicationContext().databaseDir;

                testNapi.initRDB(databaseDir);
                this.handleDataExtract();
                /*
                for(let i = 0; i < 3; i++){
                        this.optionsFormat.push(this.settings.getSettingsFormat(new Date(Date.now()), i))
                }
                * */


        }

        private async handleDataExtract(){
                let resultObjects = testNapi.searchRDB() as object[];
                for (let i: number = 0; i < resultObjects.length; i++) {

                        let newEvent = new EventItem(resultObjects[i]["id"], resultObjects[i]['title'], resultObjects[i]['date'], resultObjects[i]['repeat'], resultObjects[i]['tag'],  resultObjects[i]['top'], 1);
                        this.eventList.push(newEvent);
                        console.error("id:" + resultObjects[i]["id"]  +"    "+resultObjects[i]['title'] + " |  " + resultObjects[i]['date'] +"  |  " + resultObjects[i]['tag'] + "  |  " + resultObjects[i]['repeat'] + "  | " + resultObjects[i]['top'])

                }
        }

        private async handlePreferencesExtract(){

                this.settingsModel =  await this.settings.getPreference()

                this.customizedBackground = await this.settings.getCustomizedPhoto()
                this.valueRemind = this.optionsRemind[this.settingsModel.remindTime]
                this.valueFormat = this.optionsFormat[this.settingsModel.format]
        }

        private handleBackgroundJump(): void{
                router.pushUrl({
                        url: "pages/Background"
                }, router.RouterMode.Standard)
        }

        private handleFormatButtonClick(): void {
                this.isFormatOpen = true;
                this.isRemindOpen = false;

        }
        private handleRemindButtonClick(): void {
                this.isRemindOpen = true;
                this.isFormatOpen = false;
        }
        private handleRemindChange(value: string): void{
                this.valueRemind = value;
                let index = this.optionsRemind.indexOf(this.valueRemind)
                this.settings.changeSettings("remindTime", index.toString())
                this.reminderHandler.updateAllReminders(this.eventList, index)

        }
        private handleFormatChange(value: string): void{
                this.valueFormat = value;
                let index = this.optionsFormat.indexOf(this.valueFormat)
                this.settings.changeSettings("format", index.toString())
        }

        private handleCloseAllWindow(): void{
                this.isFormatOpen = false;
                this.isRemindOpen = false;
        }

        private handleCloseKeyBoard():void{
                let inputMethodController = inputMethod.getController();
                inputMethodController.stopInputSession();
        }

        build() {
                Column() {
                        Row() {
                                ReturnButton({url: "pages/Index"})

                                Text("             设置")
                                        .fontSize(24)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor("#ffffff").width("40%")

                        }.justifyContent(FlexAlign.Start).width("95%").margin({
                                top: '30px',    // 设置上外边距
                                bottom: '30px', // 设置下外边距
                        })
                        Column(){
                                Column(){

                                        CustomizedPicker({
                                                title: "背景主题",
                                                name: "background",
                                                type: "tag",
                                                value: this.emptyValue,
                                                onButtonClick: { click: this.handleBackgroundJump.bind(this) }
                                        })

                                        CustomizedPicker({
                                                title: "提醒时间",
                                                name: "remind",
                                                type: "remind",
                                                options: this.optionsRemind,
                                                value: this.valueRemind,
                                                onButtonClick: { click: this.handleRemindButtonClick.bind(this) }
                                        })
                                        /**/
                                        CustomizedPicker({
                                                title: "日期格式",
                                                name: "format",
                                                type: "format",
                                                options: this.optionsFormat,
                                                value: this.valueFormat,
                                                onButtonClick: { click: this.handleFormatButtonClick.bind(this) }
                                        })


                                }
                                Column(){
                                        if(this.isRemindOpen){
                                                OptionsPicker({
                                                        name: "remindOptions",
                                                        options: this.optionsRemind,
                                                        onButtonClick: { click: this.handleRemindChange.bind(this) }
                                                })
                                        }
                                        if(this.isFormatOpen){
                                                OptionsPicker({
                                                        name: "formatOptions",
                                                        options: this.optionsFormat,
                                                        onButtonClick: { click: this.handleFormatChange.bind(this) }
                                                })
                                        }
                                }
                        }.height("90%").justifyContent(FlexAlign.SpaceBetween)






                }.width('100%').height('100%').backgroundImage(this.customizedBackground)
                .backgroundImageSize(ImageSize.Cover).onClick(() => {
                        this.handleCloseAllWindow();
                })


        }
}
