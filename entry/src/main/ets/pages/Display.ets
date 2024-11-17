import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import {AddDateButton} from '../components/AddEventButton'
import { CustomizedDatePicker } from '../components/CustomizedDatePicker';
import { InputBox } from '../components/InputBox';
import { SettingsButton } from '../components/SettingsButton';
import {CustomizedPicker} from '../components/CustomizedPicker'
import { OptionsPicker } from '../components/OptionsPicker';


@Entry
@Component
struct Display {
        @State message: string = '';
        @State isDatePickerOpen: boolean = false;
        @State isTagOptionOpen: boolean = false;
        @State isRepeatOptionOpen: boolean = false;


        private tagOptions: Array<string> = ["生活", "工作", "生日", "爱情"];
        private repeatOptions: Array<string> = ["无重复", "每周重复", "每月重复", "每年重复"];
        @State date: Date = new Date(Date.now());
        @State repeatValue: string = this.repeatOptions[0];
        @State tagValue: string = this.tagOptions[0];
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
        private handleDateChange(value: Date): void{

                this.date = value
                console.log(this.date.toDateString())
        }
        private handleTagChange(value: string): void{
                this.tagValue = value;
        }
        private handleRepeatChange(value: string): void{
                this.repeatValue = value;

        }


        build() {
                Row() {
                        Column() {
                                Row() {
                                        SettingsButton()

                                        AddDateButton()

                                }.justifyContent(FlexAlign.SpaceBetween).width("100%")
                                Column(){
                                        InputBox({
                                                title: "事件名",
                                                placeHolder: "testPlaceHolder",
                                                nameBox: "test",
                                                type: "text"
                                        })
                                        CustomizedPicker({
                                                title: "日期",
                                                name: "date",
                                                type: "date",
                                                value: this.date,
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
                                        Text(this.message)
                                                .fontSize(50)
                                                .fontWeight(FontWeight.Bold)
                                                .onClick(() => {
                                                        hilog.info(0x0000, 'testTag', 'Test NAPI 2 + 3 = %{public}d',
                                                                testNapi.add(2, 3));
                                                })
                                }
                                Column(){
                                        if (this.isDatePickerOpen) {
                                                CustomizedDatePicker({
                                                        date: this.date,
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



                        }.width('100%')
                        Column(){

                        }.width('100%')
                }
                .height('100%').backgroundImage($r("app.media.background1")).backgroundImageSize(ImageSize.Cover)
        }
}
