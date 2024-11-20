import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import router from '@ohos.router';

import { CustomizedDatePicker } from '../components/CustomizedDatePicker';
import { InputBox } from '../components/InputBox';
import { SettingsButton } from '../components/SettingsButton';
import {CustomizedPicker} from '../components/CustomizedPicker'
import { OptionsPicker } from '../components/OptionsPicker';
import { EventItem } from '../model/EventModel';
import { TopEventDisplay } from '../components/TopEventDisplay';
import SettingsHandler from '../common/utils/SettingsHandler';
import { SettingsModel } from '../model/SettingsModel';
import { common } from '@kit.AbilityKit';
import { ReturnButton } from '../components/ReturnButton';
import { EditButton } from '../components/EditButton';


@Entry
@Component
struct Display {
        @State message: string = '';

        @State params: Record<string, object>  = (router.getParams() as Record<string, object>)
        @State event: EventItem = this.params["event"] as EventItem
        private context = getContext(this) as common.UIAbilityContext;
        private settings = new SettingsHandler();
        @State settingsModel: SettingsModel = {
                background: "app.media.background4",
                remindTime: 0,
                format: 0
        };
        @State customizedBackground: PixelMap | ResourceStr | undefined = undefined
        @State tempBackground: string = "app.media.background2"
        aboutToAppear(): void {
                this.handlePreferencesExtract()

        }
        private async handlePreferencesExtract(){

                this.settingsModel =  await this.settings.getPreference()

                this.customizedBackground = await this.settings.getCustomizedPhoto()
                this.tempBackground = this.settingsModel.background

        }





        build() {

                        Column() {
                                Row() {
                                        ReturnButton({url: "pages/Index"})

                                        EditButton({event: this.event})
                                }.justifyContent(FlexAlign.SpaceBetween).width("95%").margin({
                                        top: '30px',    // 设置上外边距
                                        bottom: '30px', // 设置下外边距
                                })

                                Column() {
                                        TopEventDisplay({ event: this.event })
                                }.height("100%")
                        }.height('100%').backgroundImage(this.customizedBackground).backgroundImageSize(ImageSize.Cover)
        }
}
