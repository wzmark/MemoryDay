import router from '@ohos.router';
import SettingsHandler from '../common/utils/SettingsHandler';
import { EventList, EventItem } from '../model/EventModel';
import { DayArrowSymbol } from './DayArrowSymbol';


@Component

export struct TopEventDisplay{
        @Prop event: EventItem
        @Prop date: string

        private settings: SettingsHandler = new SettingsHandler()

        async aboutToAppear(): Promise<void> {
                console.error(await this.settings.getSettingsFormat(new Date(this.event.date)))
                this.date = await this.settings.getSettingsFormat(new Date(this.event.date))
        }




        private getDaysDistance(dateStr: string): string{
                let today = new Date(Date.now());
                let eventDate = new Date(dateStr)


                const differenceInTime = today.getTime() - eventDate.getTime();
                console.error("today  " + today.getTime()  +  "   eventDate   " + eventDate.getTime())
                const differenceInDays = Math.floor(differenceInTime / (1000 * 60 * 60 * 24));
                console.error("distance Date  " + differenceInDays)
                return differenceInDays.toString()

        }

        private checkEmptyEvent(value: string): string{
                if(value === ""){
                        return "无事件"
                }
                return value
        }


        build() {
                Column(){
                        DayArrowSymbol({day: Number(this.getDaysDistance(this.event.date)), sizeOfSymbolHeight: "12%", sizeOfSymbolWidth: "8%", sizeOfFont: 80})

                        Column(){
                                Text(this.checkEmptyEvent(this.event.title))
                                        .fontSize(22)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor("#ffffff").textAlign(TextAlign.Center)


                                Text(("纪念日  "+ this.event.newDateFormat))
                                        .fontSize(14)
                                        .fontColor("#ffffff")
                                        .textAlign(TextAlign.Center)
                        }




                }.width("100%").height("20%").justifyContent(FlexAlign.Center)  // 垂直居中
                .alignItems(HorizontalAlign.Center)



        }
}