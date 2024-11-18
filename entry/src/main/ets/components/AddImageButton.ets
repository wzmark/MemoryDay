import router from '@ohos.router';

import picker from '@ohos.file.picker'
import fs from '@ohos.file.fs';
import { common } from '@kit.AbilityKit';
import { dataSharePredicates } from '@kit.ArkData';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import SettingsHandler from '../common/utils/SettingsHandler';

export interface Params{
        click: () => void
}
@Component

export struct AddImageButton{
        @State settings: SettingsHandler = new SettingsHandler();
        @Prop onButtonClick: Params
        build() {

                Button(){
                        Image($r('app.media.plus'))
                                .width('50%')
                                .height('20%')
                                .fillColor(Color.White).clip(true).borderRadius(10)
                                .border({
                                        width: "8px",
                                        color: Color.White
                                }).padding({
                                        top: '20px',   // 设置上内边距
                                        bottom: '20px'  // 设置下内边距
                                })

                }.onClick(() => {
                        this.settings.handlePhotoSelect()
                        this.settings.changeSettings("background", "customizedImage")
                        this.onButtonClick.click()
                }).backgroundColor('#00000000')
        }
}