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


@Entry
@Component
struct Settings {
        @State message: string = '';
        @State emptyValue: string = ""
        private settings = new SettingsHandler();
        private settingsModel: SettingsModel = {
                background: "app.media.background1",
                remindTime: 0,
                format: 0
        };


        aboutToAppear(): void {
                this.handlePreferencesExtract()
        }

        private async handlePreferencesExtract(){

                this.settingsModel =  await this.settings.getPreference()
        }

        private handleBackgroundJump(): void{
                router.pushUrl({
                        url: "pages/Background"
                }, router.RouterMode.Standard)
        }


        build() {
                Column() {
                        Row() {
                                ReturnButton({url: "pages/Index"})

                                Text("             设置")
                                        .fontSize(24)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor("#ffffff").width("40%")

                        }.justifyContent(FlexAlign.Start).width("95%")
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
                                        name: "date",
                                        type: "tag",
                                        value: this.emptyValue,
                                        onButtonClick: { click: this.handleBackgroundJump.bind(this) }
                                })
                                CustomizedPicker({
                                        title: "日期格式",
                                        name: "date",
                                        type: "tag",
                                        value: this.emptyValue,
                                        onButtonClick: { click: this.handleBackgroundJump.bind(this) }
                                })

                        }




                }.width('100%').height('100%').backgroundImage($r(this.settingsModel.background)).backgroundImageSize(ImageSize.Cover)


        }
}
