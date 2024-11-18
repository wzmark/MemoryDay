import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import {AddEventButton} from '../components/AddEventButton'
import { CustomizedDatePicker } from '../components/CustomizedDatePicker';
import { InputBox } from '../components/InputBox';
import { SettingsButton } from '../components/SettingsButton';
import {CustomizedPicker} from '../components/CustomizedPicker'
import { OptionsPicker } from '../components/OptionsPicker';
import { ReturnButton } from '../components/ReturnButton';
import { BackgroundImageWindow } from '../components/BackgroundImageWindow';
import SettingsHandler from '../common/utils/SettingsHandler';
import { SettingsModel } from '../model/SettingsModel';
import { AddImageButton } from '../components/AddImageButton';


@Entry
@Component
struct Background {
        @State message: string = '';
        @State backgroundList: string[] = ["background1", "background2", "background3", "background4"]
        scroller: Scroller = new Scroller()

        @State settings: SettingsHandler = new SettingsHandler();
        @State settingsModel: SettingsModel = {
                background: "app.media.background1",
                remindTime: 0,
                format: 0
        };
        @State tempBackground: string = "";


        private handleButtonClick(): void{

        }
        async aboutToAppear(): Promise<void> {
                await this.handlePreferencesExtract();
                this.tempBackground = this.settingsModel.background;
                console.log("Updated settings:", this.tempBackground);
        }

        private async handlePreferencesExtract(): Promise<void> {
                this.settingsModel = await this.settings.getPreference();
        }
        build() {
                Column() {
                        Row() {
                                ReturnButton({url: "pages/Settings"})

                                Text("             背景")
                                        .fontSize(24)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor("#ffffff").width("40%")

                        }.justifyContent(FlexAlign.Start).width("95%").margin({
                                top: '30px',    // 设置上外边距
                                bottom: '30px', // 设置下外边距
                        })
                        Grid(this.scroller){
                                ForEach(this.backgroundList, (path: string) => {
                                        GridItem(){
                                                BackgroundImageWindow({photoUrl: ("app.media." + path)})
                                                        .onClick(() =>{

                                                                this.settings.changeSettings("background", "app.media." + path)

                                                                this.tempBackground = "app.media." + path
                                                        })
                                        }
                                })
                                GridItem(){
                                        AddImageButton()
                                }
                        }.columnsTemplate('1fr 1fr 1fr')
                        .height(300).rowsGap(10)





                }.width('100%').height('100%').backgroundImage($r(this.tempBackground)).backgroundImageSize(ImageSize.Cover)


        }
}
