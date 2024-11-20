import router from '@ohos.router';
import { EventItem } from '../model/EventModel';


@Component

export struct EditButton{
        @Prop event: EventItem
        build() {

                Button("编辑").onClick(() => {
                        router.pushUrl({
                                url: "pages/Edit",
                                params: {
                                        event: this.event
                                }
                        }, router.RouterMode.Standard)
                        console.log("jump")
                }).backgroundColor('#00000000').fontColor("#ffffff").fontSize(24)
        }
}