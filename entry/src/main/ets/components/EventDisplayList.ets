import router from '@ohos.router';
import SettingsHandler from '../common/utils/SettingsHandler';
import { EventList, EventItem } from '../model/EventModel';
import { DayArrowSymbol } from './DayArrowSymbol';


@Component

export struct EventDisplayList{
        @Link   eventList: EventItem[]

        scroller: Scroller = new Scroller;


        private getDaysDistance(dateStr: string): string{
                let today = new Date(Date.now());
                let eventDate = new Date(dateStr)

                console.error("number of event " + this.eventList.length)
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

        private jumpDisplay(event: EventItem){
                router.pushUrl({
                        // 跳转页面路径
                        url: 'pages/Display',
                        // 跳转携带的参数
                        params: {
                                event: event
                        }
                }, router.RouterMode.Standard)

        }



        build() {

                Scroll(this.scroller){
                        Column(){
                                ForEach(this.eventList, (item: EventItem) => {
                                        Row(){
                                                Column(){

                                                        Text(this.checkEmptyEvent(item.title))
                                                                .fontSize(22)
                                                                .fontWeight(FontWeight.Bold)
                                                                .fontColor("#ffffff")


                                                        Text(("纪念日  "+item.newDateFormat))
                                                                .fontSize(14)
                                                                .fontColor("#ffffff")

                                                }.alignItems(HorizontalAlign.Start)
                                                        .height("100%")
                                                        .margin({ top: '100px', bottom: '10px' })
                                                DayArrowSymbol({day: Number(this.getDaysDistance(item.date)), sizeOfSymbolHeight: "6%", sizeOfSymbolWidth: "4%", sizeOfFont: 28})


                                        }.width("90%").justifyContent(FlexAlign.SpaceBetween).onClick(() => {
                                                this.jumpDisplay(item)
                                        })
                                        .border({
                                                width: {bottom: "1px"},
                                                color: {bottom: Color.White}
                                        }).height("14%")
                                })
                        }
                }


        }
}

