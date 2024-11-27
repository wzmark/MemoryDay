import SettingsHandler from "../common/utils/SettingsHandler";

export class EventItem {
        public id: number;
        public title: string;
        public date: string;
        public newDateFormat: string | undefined;
        public repeat: string;
        public tag: string;
        public top: boolean;
        public reminderId: number;

        private settings: SettingsHandler = new SettingsHandler();
        public async initNewDateFormat(): Promise<void>{
                this.newDateFormat = await this.settings.getSettingsFormat(new Date(this.date))
        }



        constructor(id:number, title: string, date: string, repeat: string, tag: string, top: boolean, reminderId: number) {
                this.id = id;
                this.title = title;
                this.date = date;
                this.repeat = repeat;
                this.tag = tag;
                this.top = top;
                this.reminderId = reminderId;


        }



}

export const EventList: EventItem[] = [];