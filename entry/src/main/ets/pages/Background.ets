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


@Entry
@Component
struct Background {
        @State message: string = '';
        @State backgroundList: string[] = ["background1", "background2", "background3", "background4"]
        scroller: Scroller = new Scroller()
        private handleButtonClick(): void{

        }


        build() {
                Column() {
                        Row() {
                                ReturnButton({url: "pages/Settings"})

                                Text("             背景")
                                        .fontSize(24)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor("#ffffff").width("40%")

                        }.justifyContent(FlexAlign.Start).width("95%")
                        Grid(this.scroller){
                                ForEach(this.backgroundList, (path: string) => {
                                        GridItem(){
                                                BackgroundImageWindow({photoUrl: ("app.media." + path)})
                                        }
                                })
                        }.columnsTemplate('1fr 1fr 1fr')
                        .height(300).rowsGap(10)





                }.width('100%').height('100%').backgroundImage($r("app.media.background1")).backgroundImageSize(ImageSize.Cover)


        }
}
