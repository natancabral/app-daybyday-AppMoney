package GNNC.modules.financial.report
{
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataArrayCollection;
	import GNNC.data.data.gnncDataNumber;
	import GNNC.data.date.DateUtils;
	import GNNC.data.date.gnncDate;
	import GNNC.data.globals.gnncGlobalArrays;
	import GNNC.data.sql.gnncSql;
	import GNNC.data.conn.gnncAMFPhp;
	import GNNC.data.file.gnncFilePdf;
	import GNNC.data.file.gnncFileReport;
	import GNNC.sqlTables.table_financial;

	public class gnncFileReport_financial_today extends gnncFileReport
	{
		static internal var _FINANCIAL:gnncAMFPhp = new gnncAMFPhp();
		static internal var _parent:Object = null;
		static internal var _gnncFilePdf:gnncFilePdf;
		
		static internal const borderHeader:uint = 0x999999;
		static internal const bgHeader:uint 	= 0xEEEEEE;
		static internal const fontHeader:uint 	= 6;
		static internal const rowHeader:uint 	= 4;
		
		static internal var   border:uint 		= 0x999999;
		static internal const bg:uint 			= 0xFFFFFF;
		static internal const font:uint 		= 9;
		static internal const row:uint 			= 4;
		
		static internal const borderAlt:uint 	= 0x999999;
		static internal const bgAlt:uint 		= 0xEEEEEE;
		static internal const fontSmall:uint 	= 8;
		static internal const fontBig:uint 		= 10;
		
		public function gnncFileReport_financial_today(csv_:Boolean=false)
		{
			_csvReturn = csv_;
		}
				
		private var _beforeTotal:Boolean = false;
		private var _nameAccount:String = '';
		override protected function __addHeader(e:*=null):void
		{
			if(Number(_report.DATA_ARR.getItemAt(0).TOTAL_BEFORE)>0 && !_beforeTotal)
			{
				_beforeTotal = true;
				_gnncFilePdf.__setFontStyle(font-1); //FONT
				_gnncFilePdf.__addCell("Saldo Anterior",								45,"L",row+2,0xDDDDDD,border);
				
				_nameAccount = Number(_object['idAccount'])>0?_object['nameAccount']:'Todas as Contas';
				_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(_nameAccount),25,"C",row+2,bgAlt,border);

				if(Number(_object['idDepartament'])>0)
					_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(_object['nameDepartament']),25,"C",row+2,bgAlt,border);
				
				_gnncFilePdf.__addCell(gnncDate.__date2Legend('',DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateStart)),25,"C",row+2,bgAlt,border);
				_gnncFilePdf.__setFontStyle(font); //FONT
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(_report.DATA_ARR.getItemAt(0).TOTAL_BEFORE),	30,"C",row+2,bg,border);
				_gnncFilePdf.__setFontStyle(font-2); //FONT
				_gnncFilePdf.__breakLine(row+3);
			}
			
			/**A4 wth margin = 190 or 260 **/
			_gnncFilePdf.__setFontStyle(gnncFileReport._headerFont); //FONT
			_gnncFilePdf.__addCell("DATA PAG.",							15 ,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("-",									5 ,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("REGISTRO",							15,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("REG. BAIXA",						15,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("CLIENTE",							40,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("CENTRO DE CUSTO",					25,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("PLANO DE CONTAS",					45,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("CONTA",								30,"C",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__breakLine(row);
			_gnncFilePdf.__addCell("DATA VENC.",						15,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("TIPO",								15,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("DESCRIÇÃO DO LANÇAMENTO",			60,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("DOC. NUM.",							25,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("DOC. TIPO",							15,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("BANCO.",						    10,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("PAG. TIPO",							13,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("BAN.",							    7,"L",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("RECEITA",							15,"C",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("DESPESA",							15,"C",rowHeader,bgHeader,borderHeader);
			_gnncFilePdf.__breakLine(row+1);
			
			_csvHeader = new Array(
				'Tipo de Lançamento',
				'Data Vencimento',
				'Data Pagamento',
				'L',
				'Registro',
				'Registro Baixa',
				'Cliente',
				'Centro de Custo',
				'Plano de Contas',
				'Conta',
				'Descrição',
				'Num. Doc',
				'Doc. Tipo',
				'Receita',
				'R. Transf.',
				'R. Prevista',
				'Despesa',
				'D. Transf.',
				'D. Prevista'
			);

			_gnncFilePdf.__setFontStyle(font-1); //FONT

			_gnncFilePdf.__clearAll();


		} 
		
		override protected function __addResume(object_:Object):void
		{

			_gnncFilePdf.__setFontStyle(_headerFont-2,0x777777); //FONT
			_gnncFilePdf.__addCell(
				
				'Antes ' +
				gnncDataNumber.__safeReal(object_.TOTAL_BEFORE) +' (Pag) / '+
				gnncDataNumber.__safeReal(object_.TOTAL_BEFORE_END)+' (Venc) | '+
				'Depois ' +
				gnncDataNumber.__safeReal(object_.TOTAL_AFTER)  +' (Pag) / '+
				gnncDataNumber.__safeReal(object_.TOTAL_AFTER_END) +' (Venc) ' 

				,190,"C",rowHeader,0,0);
			

			_gnncFilePdf.__breakLine(row);
			
			/*if(object_.hasOwnProperty('TOTAL_TODAY_IN'))
			{
				/ **A4 wth margin = 190 or 260 ** /
				//### NEW LINE
				_gnncFilePdf.__setFontStyle(_headerFont); //FONT
				_gnncFilePdf.__addCell("",														90,"C",rowHeader+rowHeader,bgHeader,borderHeader);
				_gnncFilePdf.__addCell("RECEITA",												20,"C",rowHeader,bgHeader,borderHeader);
				_gnncFilePdf.__addCell("DESPESA",												20,"C",rowHeader,bgHeader,borderHeader);
				_gnncFilePdf.__addCell("MOVIMENTO ("+_itemRenderLength+")",						60,"C",rowHeader,bgHeader,borderHeader);
				_gnncFilePdf.__breakLine(row);
				
				//### NEW LINE
				_gnncFilePdf.__setFontStyle(font-1); //FONT
				_gnncFilePdf.__addCell("RESPONSÁVEL:",											90,"L",0.1,0,0);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.TOTAL_TODAY_IN),		20,"C",row,bgHeader,border);
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.TOTAL_TODAY_OUT),		20,"C",row,bgHeader,border);
				_gnncFilePdf.__setFontStyle(font); //FONT
				_gnncFilePdf.__addCell(" = "+gnncDataNumber.__safeReal(Number(object_.TOTAL_TODAY_IN-object_.TOTAL_TODAY_OUT)),60,"C",row,bgHeader,border);
				_gnncFilePdf.__breakLine(row);
				
				_gnncFilePdf.__addLine(0x000000,0.2);
				_gnncFilePdf.__breakLine(row);
			}*/

			if( ( ValorTotalLancamentoInNoCount > 0 || ValorTotalLancamentoOutNoCount > 0 ) || (Number(object_.TOTAL_TODAY_IN)>0 || Number(object_.TOTAL_TODAY_OUT)>0))
			{
				/**A4 wth margin = 190 or 260 **/
				//### NEW LINE
				_gnncFilePdf.__setFontStyle(_headerFont); //FONT
				_gnncFilePdf.__addCell("",															90,"C",rowHeader+rowHeader+rowHeader,bgHeader,borderHeader);
				_gnncFilePdf.__addCell("",													        20,"C",rowHeader,bgHeader,borderHeader);
				_gnncFilePdf.__addCell("RECEITA",													20,"C",rowHeader,bgHeader,borderHeader);
				_gnncFilePdf.__addCell("DESPESA",													20,"C",rowHeader,bgHeader,borderHeader);
				_gnncFilePdf.__addCell("MOVIMENTO",													40,"C",rowHeader,bgHeader,borderHeader);
				_gnncFilePdf.__breakLine(row);
				
				if(object_.hasOwnProperty('TOTAL_TODAY_IN')==true)
				{
					//### NEW LINE
					_gnncFilePdf.__setFontStyle(font-1); //FONT
					_gnncFilePdf.__addCell("RESPONSÁVEL:",												90,"L",0.1,0,0);
					_gnncFilePdf.__setFontStyle(_headerFont); //FONT
					_gnncFilePdf.__addCell("FATURADO (SQL)",											20,"L",row,bgHeader,border);
					_gnncFilePdf.__setFontStyle(font-1); //FONT
					_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.TOTAL_TODAY_IN),			20,"C",row,bgHeader,border);
					_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.TOTAL_TODAY_OUT),			20,"C",row,bgHeader,border);
					_gnncFilePdf.__setFontStyle(font); //FONT
					_gnncFilePdf.__addCell(" = "+gnncDataNumber.__safeReal(Number(object_.TOTAL_TODAY_IN-object_.TOTAL_TODAY_OUT)),40,"C",row,bgHeader,border);
					_gnncFilePdf.__breakLine(row);
				}
				

				if( ValorTotalLancamentoIn > 0 || ValorTotalLancamentoOut > 0 )
				{
					//### NEW LINE
					_gnncFilePdf.__setFontStyle(font-1); //FONT
					//_gnncFilePdf.__addCell("RESPONSÁVEL:",															90,"L",0.1,0,0);
					_gnncFilePdf.__addCell("",															90,"L",0.1,0,0);
					_gnncFilePdf.__setFontStyle(_headerFont); //FONT
					_gnncFilePdf.__addCell("FATURADO (PC)",												20,"L",row,bgHeader,border);
					_gnncFilePdf.__setFontStyle(font-1); //FONT
					_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ValorTotalLancamentoIn),	20,"C",row,bgHeader,border);
					_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ValorTotalLancamentoOut),	20,"C",row,bgHeader,border);
					_gnncFilePdf.__setFontStyle(font); //FONT
					_gnncFilePdf.__addCell(" = "+gnncDataNumber.__safeReal(ValorTotalLancamentoIn-ValorTotalLancamentoOut),40,"C",row,bgHeader,border);
					_gnncFilePdf.__breakLine(row);
				}

				if( ValorTotalLancamentoInNoCount > 0 || ValorTotalLancamentoOutNoCount > 0 )
				{
					//### NEW LINE
					_gnncFilePdf.__setFontStyle(font-1); //FONT
					_gnncFilePdf.__addCell("",															90,"L",0.1,0,0);
					_gnncFilePdf.__setFontStyle(_headerFont); //FONT
					_gnncFilePdf.__addCell("PREVISTO",													20,"L",row,bgHeader,border);
					_gnncFilePdf.__setFontStyle(font-1); //FONT
					_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ValorTotalLancamentoInNoCount),	20,"C",row,bgHeader,border);
					_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ValorTotalLancamentoOutNoCount),	20,"C",row,bgHeader,border);
					_gnncFilePdf.__setFontStyle(font); //FONT
					_gnncFilePdf.__addCell(" = "+gnncDataNumber.__safeReal(ValorTotalLancamentoInNoCount-ValorTotalLancamentoOutNoCount),40,"C",row,bgHeader,border);
					_gnncFilePdf.__breakLine(row);
				}

				_gnncFilePdf.__addLine(0x000000,0.2);
				_gnncFilePdf.__breakLine(row);
			}

			/*{label: 'America Express',		data: 'AME', 	image: 'americanex'		},
			{label: 'Dinesclub',			data: 'DIN', 	image: 'dinesclub'		},
			{label: 'Elo',					data: 'ELO', 	image: 'elo'			},
			{label: 'MasterCard',			data: 'MAS', 	image: 'mastercard'		},
			{label: 'Visa',					data: 'VIS', 	image: 'visa'			},
			{label: 'Hipercard',			data: 'HIP', 	image: 'hipercard'		},
			{label: 'Outro',			    data: 'OTH', 	image: 'otherflag'		}

			{label: 'Dinheiro', 			data: 'DINHEI', nick:'Dinheiro'},
			{label: 'Cartão de Crédito', 	data: 'CCREDT', nick:'CCrédito'},
			{label: 'Cartão de Débito', 	data: 'CDEBIT', nick:'CDébito'},
			{label: 'Cheque', 				data: 'CHEQUE', nick:'Cheque'},
			{label: 'Crédito Próprio', 		data: 'CREDTP', nick:'CrédPróp'},
			{label: 'Depósito em CC', 	    data: 'DEPOCC', nick:'Depósito'},
			{label: 'Transf. Bancária', 	data: 'TRANSB', nick:'Transf.B.'}
			*/

			
			_gnncFilePdf.__setFontStyle(gnncFileReport._headerFont); //FONT
			_gnncFilePdf.__addCell("",10 ,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Dinheiro"															,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("C.Crédito"															,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("C.Débito"															,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Cheque"																,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Crédito Próp."														,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Depósito CC"														,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Débito em C."														,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Transf. Banc."														,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Total"																,20,"C",row,0xAAAAAA,0xAAAAAA);
			_gnncFilePdf.__breakLine(row);
			_gnncFilePdf.__addCell("Receita",10,"L",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt0In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt1In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt2In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt3In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt4In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt5In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt6In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt7In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt8In)		,20,"C",row,bg,border);
			_gnncFilePdf.__breakLine(row);
			_gnncFilePdf.__addCell("Despesa",10,"L",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt0Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt1Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt2Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt3Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt4Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt5Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt6Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt7Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(pt8Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__breakLine(row);

			_gnncFilePdf.__addCell("",10,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("A. Express"															,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Dinesclub"															,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Elo"																,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("MasterCard"															,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Visa"																,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Hipercard"															,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Outra Bandeira"														,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Outros"																,20,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("Total"																,20,"C",row,0xAAAAAA,0xAAAAAA);
			_gnncFilePdf.__breakLine(row);
			_gnncFilePdf.__addCell("Receita",10,"L",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft0In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft1In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft2In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft3In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft4In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft5In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft6In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft7In)		,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft8In)		,20,"C",row,bg,border);
			_gnncFilePdf.__breakLine(row);
			_gnncFilePdf.__addCell("Despesa",10,"L",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft0Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft1Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft2Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft3Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft4Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft5Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft6Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft7Out)	,20,"C",row,bg,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(ft8Out)	,20,"C",row,bg,border);

			_gnncFilePdf.__breakLine(row);

			_gnncFilePdf.__addLine(0x000000,0.2);
			_gnncFilePdf.__breakLine(row);

			if(Number(object_.VALUE_IN_ACTIVE_1)>0 || Number(object_.VALUE_OUT_ACTIVE_1)>0){
			//### Pendencias Financeiras
			_gnncFilePdf.__setFontStyle(gnncFileReport._headerFont); //FONT
			_gnncFilePdf.__addCell("PENDÊNCIAS"															,27,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("RECEITA"															,27,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell("DESPESA"															,27,"C",row,bgHeader,borderHeader);
			_gnncFilePdf.__addCell(''																	,1, "C",row,0,0);
			/*_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__breakLine(row);
			*/
			_gnncFilePdf.__breakLine(row);
			
			_gnncFilePdf.__setFontStyle(font-1); //FONT
			_gnncFilePdf.__addCell(''+uint(object_.ROWS_ACTIVE_1)										,27,"C",row,bgHeader,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_IN_ACTIVE_1)					,27,"C",row,bgHeader,border);
			_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.VALUE_OUT_ACTIVE_1)				,27,"C",row,bgHeader,border);			
			_gnncFilePdf.__addCell(''																	,1, "C",row,0,0);
			/*_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__addCell(''																	,27,"C",row,bg,border);
			_gnncFilePdf.__breakLine(row);
			*/
			_gnncFilePdf.__breakLine(row);
			_gnncFilePdf.__addLine(0x000000,0.2);
			//###
		}

			_gnncFilePdf.__breakLine(row);

			if(object_.hasOwnProperty('TOTAL_BEFORE')==true)
			{
				//### NEW LINE
				_gnncFilePdf.__setFontStyle(gnncFileReport._headerFont); //FONT
				_gnncFilePdf.__addCell("ANOTAÇÕES ADICIONAIS",									66,"C",rowHeader,bgHeader,borderHeader);
				_gnncFilePdf.__addCell(_nameAccount,											42,"C",rowHeader,0xAAAAAA,0xAAAAAA);
				_gnncFilePdf.__addCell("CÁLCULO ADICIONAL DE CONFIRMAÇÃO DOS SALDOS",			82,"C",rowHeader,bgHeader,borderHeader);
				_gnncFilePdf.__breakLine(row);

				var dateStartYesterday:String = gnncDate.__date2Legend('',DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateStart));

				//### NEW LINE
				_gnncFilePdf.__setFontStyle(font-1); //FONT
				_gnncFilePdf.__addCell("",														66,"L",row+1,bg,border);
				_gnncFilePdf.__addCell("Saldo "+dateStartYesterday,								42,"L",row+1,bgAlt,border);
				_gnncFilePdf.__setFontStyle(font); //FONT
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.TOTAL_BEFORE),			34,"C",row+1,bg,border);
				_gnncFilePdf.__setFontStyle(font-2); //FONT
				_gnncFilePdf.__addCell("+ "+gnncDataNumber.__safeReal(object_.TOTAL_TODAY_IN,2,'')+"",	24,"C",row+1,bg,border);
				_gnncFilePdf.__addCell("= "+gnncDataNumber.__safeReal(Number(object_.TOTAL_TODAY_IN)+Number(object_.TOTAL_BEFORE)),24,"C",row+1,bgAlt,border);
				_gnncFilePdf.__breakLine(row+1);
				
				//### NEW LINE
				_gnncFilePdf.__setFontStyle(font-1); //FONT
				_gnncFilePdf.__addCell("",														66,"L",row+1,bg,border);
				_gnncFilePdf.__addCell("Saldo "+gnncDate.__date2Legend('',_dateEnd),			42,"L",row+1,bgAlt,border);
				_gnncFilePdf.__setFontStyle(font); //FONT
				_gnncFilePdf.__addCell(gnncDataNumber.__safeReal(object_.TOTAL_AFTER),			34,"C",row+1,bg,border);
				_gnncFilePdf.__setFontStyle(font-2); //FONT
				_gnncFilePdf.__addCell("+ "+gnncDataNumber.__safeReal(object_.TOTAL_TODAY_OUT,2,'')+"",24,"C",row+1,bg,border);
				_gnncFilePdf.__addCell("= "+gnncDataNumber.__safeReal(Number(object_.TOTAL_TODAY_OUT)+Number(object_.TOTAL_AFTER)),24,"C",row+1,bgAlt,border);
				_gnncFilePdf.__breakLine(row+1);
				
				//### NEW LINE
				_gnncFilePdf.__setFontStyle(font-1); //FONT
				_gnncFilePdf.__addCell("",															66,"L",row,bg,border);
				_gnncFilePdf.__addCell("O valor somado a direita não representa nenhum valor real",	124,"C",row,bg,border);			
				_gnncFilePdf.__breakLine(row);
				
				_gnncFilePdf.__addLine(0x000000,0.2);
				_gnncFilePdf.__breakLine(row);
			}
			
			var csv:Array = new Array( 
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'(Total R.)',
				'(Total R. T.)',
				'(Total R. P.)',
				'(Total D.)',
				'(Total D. T.)',
				'(Total D. P.)'
			);
			
			_csvFooter += csv.join(_csvSeparator) + _csvBreakLine;

			csv	= new Array( 
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				gnncDataNumber.__safeReal(ValorTotalLancamentoIn),//object_.TOTAL_TODAY_IN
				gnncDataNumber.__safeReal(ValorTotalLancamentoInTrans),
				gnncDataNumber.__safeReal(ValorTotalLancamentoInNoCount),
				gnncDataNumber.__safeReal(ValorTotalLancamentoOut),//object_.TOTAL_TODAY_OUT
				gnncDataNumber.__safeReal(ValorTotalLancamentoOutTrans),
				gnncDataNumber.__safeReal(ValorTotalLancamentoOutNoCount) 
			);
			
			_csvFooter += csv.join(_csvSeparator) + _csvBreakLine;

			csv	= new Array( 
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				gnncDataNumber.__safeReal(object_.TOTAL_TODAY_IN),
				'',
				'',
				gnncDataNumber.__safeReal(object_.TOTAL_TODAY_OUT),
				''
			);
			
			_csvFooter += csv.join(_csvSeparator) + _csvBreakLine;
		}
		
		public var ValorTotalLancamentoIn:Number = 0;
		public var ValorTotalLancamentoOut:Number = 0;
		public var ValorTotalLancamentoInTrans:Number = 0;
		public var ValorTotalLancamentoOutTrans:Number = 0;
		public var ValorTotalLancamentoInNoCount:Number = 0;
		public var ValorTotalLancamentoOutNoCount:Number = 0;
		
		//payment type
		public var pt0In:Number = 0;
		public var pt1In:Number = 0;
		public var pt2In:Number = 0;
		public var pt3In:Number = 0;
		public var pt4In:Number = 0;
		public var pt5In:Number = 0;
		public var pt6In:Number = 0;
		public var pt7In:Number = 0;
		public var pt8In:Number = 0; //total

		public var pt0Out:Number = 0;
		public var pt1Out:Number = 0;
		public var pt2Out:Number = 0;
		public var pt3Out:Number = 0;
		public var pt4Out:Number = 0;
		public var pt5Out:Number = 0;
		public var pt6Out:Number = 0;
		public var pt7Out:Number = 0;
		public var pt8Out:Number = 0; //total

		//flag card type
		public var ft0In:Number = 0;
		public var ft1In:Number = 0;
		public var ft2In:Number = 0;
		public var ft3In:Number = 0;
		public var ft4In:Number = 0;
		public var ft5In:Number = 0;
		public var ft6In:Number = 0;
		public var ft7In:Number = 0;
		public var ft8In:Number = 0; //total

		public var ft0Out:Number = 0;
		public var ft1Out:Number = 0;
		public var ft2Out:Number = 0;
		public var ft3Out:Number = 0;
		public var ft4Out:Number = 0;
		public var ft5Out:Number = 0;
		public var ft6Out:Number = 0;
		public var ft7Out:Number = 0;
		public var ft8Out:Number = 0; //total

		override protected function __itemRender(object_:Object,i_:uint,objectAlternative_:Object=null):void
		{
			_gnncFilePdf.__clearFillStyle();
			_gnncFilePdf.__clearFontStyle()
			_gnncFilePdf.__clearStrokeStyle();

			if(object_.MIX == 'FINANCIAL_NOTE')
			{
				/**A4 wth margin = 190 or 260 **/
				_gnncFilePdf.__setFontStyle(font-1); //FONT
				_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_END,null,true,false,'-',true),	15,"L",row,0xDDDDDD,border);
				_gnncFilePdf.__setFontStyle(font); //FONT
				_gnncFilePdf.__addCell('Nota',																175,"L",row,bg,border);
				_gnncFilePdf.__breakLine(row);
				_gnncFilePdf.__setFontStyle(font-1); //FONT
				_gnncFilePdf.__addCell(gnncData.__replace(object_.DESCRIPTION,";",","),						190,"L",row,bgAlt,border);
				_gnncFilePdf.__breakLine(row);
				_gnncFilePdf.__addLine(0x000000,0.2);
				
				return;
			}
			
			var _taxWhithTransf:uint    = 0;
			var _valueSymbol:String     = Number(object_.VALUE_IN)>0 ?'(+) ':Number(object_.VALUE_OUT)>0 ?'(-) ':'';
			var _canceled:Boolean       = gnncDate.__isValid(object_.DATE_CANCELED)?true:false;
			
			if(object_.IS_TAX==1 && object_.IS_TRANS==1)
				_taxWhithTransf = 1;
			
			//object_.MIX=='FINANCIAL_TRANS'?'TRANSF.':
			var _typeSafe:String 		      = 
				_canceled==true               ?'CANCELADO':
				Number(_taxWhithTransf)==1    ?'TAXA TRANSF.':
				Number(object_.IS_TAX)==1     ?'TAXA':
				Number(object_.IS_TRANS)==1   ?'TRANSFERÊNC.':
				Number(object_.IS_REVERSAL)==1?'ESTORNO.':
				Number(object_.VALUE_IN )>0   ?'RECEITA':
				Number(object_.VALUE_OUT)>0   ?'DESPESA':
				'OUTRO';
			
			_typeSafe = _valueSymbol+_typeSafe;

			/**A4 wth margin = 190 or 260 **/
			_gnncFilePdf.__setFontStyle(font-1); //FONT
			_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_FINAL,null,true,false,'-',true),				15,"L",row,0xDDDDDD,border);
			_gnncFilePdf.__setFontStyle(font); //FONT
			_gnncFilePdf.__addCell(object_.NUMBER_LETTER,															5,"L",row,bg,border);
			_gnncFilePdf.__addCell(object_.NUMBER,																	15,"L",row,bg,border);
			_gnncFilePdf.__addCell(Number(object_.NUMBER_FINAL_PAY)>0?(object_.MIX=='FINANCIAL_TRANS'?'T':Number(object_.VALUE_IN)>0?'R':Number(object_.VALUE_OUT)>0?'D':'')+object_.NUMBER_FINAL_PAY:'',15,"L",row,bg,border);
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_CLIENT),							40,"L",row,bg,border);
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_DEPARTAMENT),						25,"L",row,bg,border);
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_GROUP),								45,"L",row,bg,border);
			_gnncFilePdf.__setFontStyle(font-1); //FONT
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.NAME_FINANCIAL_ACCOUNT),					30,"L",row,bg,border);
			
			_gnncFilePdf.__breakLine(row);
			
			_gnncFilePdf.__setFontStyle(font-1,0x777777); //FONT
			_gnncFilePdf.__addCell(gnncDate.__date2Legend(object_.DATE_END,null,true,false,'-',true),				15,"L",row,0xEEEEEE,border);
			_gnncFilePdf.__setFontStyle(font-5); //FONT
			_gnncFilePdf.__addCell(_typeSafe,																		15,"L",row,0xEEEEEE,border);
			_gnncFilePdf.__setFontStyle(font-2); //FONT
			_gnncFilePdf.__addCell(gnncData.__replace(object_.DESCRIPTION,";",","),									60,"L",row,(!_canceled)?bg:bgAlt,border);
			_gnncFilePdf.__addCell(gnncData.__firstLetterUpperCase(object_.DOCUMENT_NUMBER),						25,"L",row,(!_canceled)?bg:bgAlt,border);
			_gnncFilePdf.__addCell(object_.DOCUMENT_TYPE?new gnncDataArrayCollection().__filterNumeric(gnncGlobalArrays._FINANCIAL_DOCUMENT_TYPE,'data',Number(object_.DOCUMENT_TYPE)).getItemAt(0).nick:'',15,"L",row,(!_canceled)?bg:bgAlt,border);
			_gnncFilePdf.__addCell(object_.DOCUMENT_BANK                                                            ,10,"L",row,(!_canceled)?bg:bgAlt,border);
			_gnncFilePdf.__addCell(object_.PAY_TYPE!=''?new gnncDataArrayCollection().__filter(gnncGlobalArrays._FINANCIAL_PAY_TYPE,'data',object_.PAY_TYPE).getItemAt(0).nick:'',13,"L",row,bgAlt,border);
			_gnncFilePdf.__addCell(object_.FLAG_CARD,7,"C",row,bgAlt,border);
			
			var vi:String  = '';
			var vo:String  = '';
			var viT:String = '';
			var voT:String = '';
			var viP:String = '';
			var voP:String = '';

			//faturado e não é uma transferencia
			if( ( Number(object_.VALUE_IN_PAY) > 0 || Number(object_.VALUE_OUT_PAY) > 0 ) && object_.MIX != 'FINANCIAL_TRANS'){

				//nao é uma transferencia
				//faturado + 0.00001 = lançamento é parte de um pagamento
				if( Number(object_.VALUE_IN_PAY) == 0.00001 || Number(object_.VALUE_OUT_PAY) == 0.00001 ){

					//receita paga (R$ 0.00001)
					if(Number(object_.VALUE_IN_PAY) == 0.00001)
					{
						vi = gnncDataNumber.__safeReal(object_.VALUE_IN ,2,'');
						//id_pay_part || number pay
						vo = 'R'+(Number(object_.THIS_IS_NUMBER_FINAL_PAY)>0?object_.THIS_IS_NUMBER_FINAL_PAY:'');
					}
					//despesa paga (R$ 0.00001)
					else if(Number(object_.VALUE_OUT_PAY) == 0.00001)
					{
						vo = gnncDataNumber.__safeReal(object_.VALUE_OUT,2,'');
						//id_pay_part || number pay
						vi = 'D'+(Number(object_.THIS_IS_NUMBER_FINAL_PAY)>0?object_.THIS_IS_NUMBER_FINAL_PAY:'');
					}

					_gnncFilePdf.__setFontStyle(font-2,0x000000); //FONT
					_gnncFilePdf.__addCell(vi,	15,"R",row,bg,border);
					_gnncFilePdf.__addCell(vo,	15,"R",row,bg,border);
					
					ValorTotalLancamentoIn  += 0;
					ValorTotalLancamentoOut += 0;
					
				}
				//nao é uma transferencia
				//faturado, não é parte de um pagamento
				else
				{
					vi = Number(object_.VALUE_IN_PAY )>0?gnncDataNumber.__safeReal(object_.VALUE_IN_PAY ,2,''):'';
					vo = Number(object_.VALUE_OUT_PAY)>0?gnncDataNumber.__safeReal(object_.VALUE_OUT_PAY,2,''):'';
					_gnncFilePdf.__setFontStyle(font); //FONT
					_gnncFilePdf.__addCell(vi,	15,"R",row,bgAlt,border);
					_gnncFilePdf.__addCell(vo,	15,"R",row,bgAlt,border);
					
					ValorTotalLancamentoIn  += Number(object_.VALUE_IN_PAY);
					ValorTotalLancamentoOut += Number(object_.VALUE_OUT_PAY);
				}

			}
			//é uma transferencia
			else if(object_.IS_TRANS == 1 && object_.MIX == 'FINANCIAL_TRANS')
			{
				viT = Number(object_.VALUE_IN_PAY)>0? gnncDataNumber.__safeReal(Number(object_.VALUE_IN_PAY) ,2,''):'';
				voT = Number(object_.VALUE_OUT_PAY)>0?gnncDataNumber.__safeReal(Number(object_.VALUE_OUT_PAY),2,''):'';
				
				if(gnncDate.__isNull(object_.DATE_FINAL)){
					_gnncFilePdf.__setFontStyle(font-2,0x000000); //FONT
					_gnncFilePdf.__addCell(viT,	15,"R",row,0xCCCCCC,border);
					_gnncFilePdf.__addCell(voT,	15,"R",row,0xCCCCCC,border);
				}
				else
				{
					_gnncFilePdf.__setFontStyle(font); //FONT
					_gnncFilePdf.__addCell(viT,	15,"R",row,bgAlt,border);
					_gnncFilePdf.__addCell(voT,	15,"R",row,bgAlt,border);
				}
				
				ValorTotalLancamentoInTrans  += Number(object_.VALUE_IN_PAY)>0? Number(object_.VALUE_IN_PAY) :0;
				ValorTotalLancamentoOutTrans += Number(object_.VALUE_OUT_PAY)>0?Number(object_.VALUE_OUT_PAY):0;
			}
			//nao faturado, em aberto
			else
			{
				viP = Number(object_.VALUE_IN) >0?gnncDataNumber.__safeReal(Number(object_.VALUE_FINAL) ,2,''):'';
				voP = Number(object_.VALUE_OUT)>0?gnncDataNumber.__safeReal(Number(object_.VALUE_FINAL),2,''):'';
				
				_gnncFilePdf.__setFontStyle(font-2,0x666666); //FONT
				_gnncFilePdf.__addCell(viP,	15,"R",row,bg,border);
				_gnncFilePdf.__addCell(voP,	15,"R",row,bg,border);

				ValorTotalLancamentoInNoCount  += Number(object_.VALUE_IN) >0? Number(object_.VALUE_FINAL) :0;
				ValorTotalLancamentoOutNoCount += Number(object_.VALUE_OUT)>0?Number(object_.VALUE_FINAL):0;
			}
			
			//###########################################################################
			//###########################################################################
			// TIPO DE PAGAMENTO
			/*
			{label: 'Dinheiro', 			data: 'DINHEI', nick:'Dinheiro'},
			{label: 'Cartão de Crédito', 	data: 'CCREDT', nick:'CCrédito'},
			{label: 'Cartão de Débito', 	data: 'CDEBIT', nick:'CDébito'},
			{label: 'Cheque', 				data: 'CHEQUE', nick:'Cheque'},
			{label: 'Crédito Próprio', 		data: 'CREDTP', nick:'CrédPróp'},
			{label: 'Depósito em CC', 	    data: 'DEPOCC', nick:'Depósito'},
			{label: 'Transf. Bancária', 	data: 'TRANSB', nick:'Transf.B.'}
			
			{label: 'America Express',		data: 'AME', 	image: 'americanex'		},
			{label: 'Dinesclub',			data: 'DIN', 	image: 'dinesclub'		},
			{label: 'Elo',					data: 'ELO', 	image: 'elo'			},
			{label: 'MasterCard',			data: 'MAS', 	image: 'mastercard'		},
			{label: 'Visa',					data: 'VIS', 	image: 'visa'			},
			{label: 'Hipercard',			data: 'HIP', 	image: 'hipercard'		},
			{label: 'Outro',			    data: 'OTH', 	image: 'otherflag'		}

			*/
			
			if(Number(object_.VALUE_IN_PAY)>0)
			{
				switch(object_.PAY_TYPE)
				{
					case 'DINHEI': pt0In += Number(object_.VALUE_IN_PAY);  break;
					case 'CCREDT': pt1In += Number(object_.VALUE_IN_PAY);  break;
					case 'CDEBIT': pt2In += Number(object_.VALUE_IN_PAY);  break;
					case 'CHEQUE': pt3In += Number(object_.VALUE_IN_PAY);  break;
					case 'CREDTP': pt4In += Number(object_.VALUE_IN_PAY);  break;
					case 'DEPOCC': pt5In += Number(object_.VALUE_IN_PAY);  break;
					case 'DEBTCC': pt6In += Number(object_.VALUE_IN_PAY);  break;
					case 'TRANSB': pt7In += Number(object_.VALUE_IN_PAY);  break;
					//default:     pt8In += Number(object_.VALUE_IN_PAY);  break;
				}
				//total
				pt8In += Number(object_.VALUE_IN_PAY);
				
				if(object_.PAY_TYPE=='CCREDT' || object_.PAY_TYPE=='CDEBIT')
				{
					switch(object_.FLAG_CARD)
					{
						case 'AME': ft0In += Number(object_.VALUE_IN_PAY);  break;
						case 'DIN': ft1In += Number(object_.VALUE_IN_PAY);  break;
						case 'ELO': ft2In += Number(object_.VALUE_IN_PAY);  break;
						case 'MAS': ft3In += Number(object_.VALUE_IN_PAY);  break;
						case 'VIS': ft4In += Number(object_.VALUE_IN_PAY);  break;
						case 'HIP': ft5In += Number(object_.VALUE_IN_PAY);  break;
						case 'OTH': ft6In += Number(object_.VALUE_IN_PAY);  break;
						default:    ft7In += Number(object_.VALUE_IN_PAY);  break;
					}
					//total
					ft8In += Number(object_.VALUE_IN_PAY);
				}
			}
			else if(Number(object_.VALUE_OUT_PAY)>0)
			{
				switch(object_.PAY_TYPE)
				{
					case 'DINHEI': pt0Out += Number(object_.VALUE_OUT_PAY);  break;
					case 'CCREDT': pt1Out += Number(object_.VALUE_OUT_PAY);  break;
					case 'CDEBIT': pt2Out += Number(object_.VALUE_OUT_PAY);  break;
					case 'CHEQUE': pt3Out += Number(object_.VALUE_OUT_PAY);  break;
					case 'CREDTP': pt4Out += Number(object_.VALUE_OUT_PAY);  break;
					case 'DEPOCC': pt5Out += Number(object_.VALUE_OUT_PAY);  break;
					case 'DEBTCC': pt6Out += Number(object_.VALUE_OUT_PAY);  break;
					case 'TRANSB': pt7Out += Number(object_.VALUE_OUT_PAY);  break;
					//default:     pt8Out += Number(object_.VALUE_OUT_PAY);  break;
				}
				//total
				pt8Out += Number(object_.VALUE_OUT_PAY);

				if(object_.PAY_TYPE=='CCREDT' || object_.PAY_TYPE=='CDEBIT')
				{
					switch(object_.FLAG_CARD)
					{
						case 'AME': ft0Out += Number(object_.VALUE_OUT_PAY);  break;
						case 'DIN': ft1Out += Number(object_.VALUE_OUT_PAY);  break;
						case 'ELO': ft2Out += Number(object_.VALUE_OUT_PAY);  break;
						case 'MAS': ft3Out += Number(object_.VALUE_OUT_PAY);  break;
						case 'VIS': ft4Out += Number(object_.VALUE_OUT_PAY);  break;
						case 'HIP': ft5Out += Number(object_.VALUE_OUT_PAY);  break;
						case 'OTH': ft6Out += Number(object_.VALUE_OUT_PAY);  break;
						default:    ft7Out += Number(object_.VALUE_OUT_PAY);  break;
					}
					//total
					ft8Out += Number(object_.VALUE_OUT_PAY);
				}

			}

			// TIPO DE PAGAMENTO
			//###########################################################################
			//###########################################################################

			_gnncFilePdf.__breakLine(row);
			_gnncFilePdf.__addLine(0x000000,0.2);
			
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
			//#################### ADD LINE OF DATE_CANCELED MOTIVE
			//#################### ADD LINE OF DATE_CANCELED MOTIVE

			var csv:Array = new Array( 
				_typeSafe,
				gnncDate.__date2Legend(object_.DATE_END,null,true,false,'-',true) ,
				gnncDate.__date2Legend(object_.DATE_FINAL,null,true,false,'-',true) ,
				object_.NUMBER_LETTER ,
				object_.NUMBER ,
				Number(object_.NUMBER_FINAL_PAY)>0?(object_.MIX=='FINANCIAL_TRANS'?'T':Number(object_.VALUE_IN)>0?'R':Number(object_.VALUE_OUT)>0?'D':'')+object_.NUMBER_FINAL_PAY:'',
				gnncData.__firstLetterUpperCase(object_.NAME_CLIENT) ,
				gnncData.__firstLetterUpperCase(object_.NAME_DEPARTAMENT) ,
				gnncData.__firstLetterUpperCase(object_.NAME_GROUP) ,
				gnncData.__firstLetterUpperCase(object_.NAME_FINANCIAL_ACCOUNT) ,
				gnncData.__replace(object_.DESCRIPTION,';',','),
				object_.DOCUMENT_NUMBER,
				object_.DOCUMENT_TYPE?new gnncDataArrayCollection().__filterNumeric(gnncGlobalArrays._FINANCIAL_DOCUMENT_TYPE,'data',Number(object_.DOCUMENT_TYPE)).getItemAt(0).label:'' ,
				vi ,
				viT ,
				viP ,
				vo ,
				voT ,
				voP 
			);

			_csvContent += csv.join(_csvSeparator) + _csvBreakLine;
			
		}
		
		override protected function __finalReport(e:*=null):void
		{
		}
		
		override protected function __setValues():void
		{
			//start
			var dateStartCurrent:String   = gnncDate.__date2String(_dateStart,false);
			var dateStartYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateStart),false);
			//end
			var dateEndCurrent:String   = gnncDate.__date2String(_dateEnd,false);
			var dateEndYesterday:String = gnncDate.__date2String(DateUtils.dateAdd(DateUtils.DAY_OF_MONTH,-1,_dateEnd),false);
			
			var dateLegend:String = dateStartCurrent.substr(0,10)==dateEndCurrent.substr(0,10)? gnncDate.__date2Legend('',_dateStart) : gnncDate.__date2Legend('',_dateStart) + ' até ' + gnncDate.__date2Legend('',_dateEnd);
			
			_fileName 		= "DAYBYDAY - MONEY - Movimento Diario";
			_documentTitle 	= "Movimento Diário (Vencimento e Baixados) - "+dateLegend;

			var idAccount:String 		= Number(_object['idAccount'])     >0? " AND ID_FINANCIAL_ACCOUNT = '" + _object['idAccount']   + "' " : '' ;
			var idDepartament:String 	= Number(_object['idDepartament']) >0? " AND ID_DEPARTAMENT = '" 	+ _object['idDepartament'] 	+ "' " : '' ;
			var idGroup:String 			= Number(_object['idGroup'])       >0? " AND ID_GROUP = '" 			+ _object['idGroup'] 		+ "' " : '' ;
			var idCategory:String 		= Number(_object['idCategory'])    >0? " AND ID_CATEGORY = '" 		+ _object['idCategory'] 	+ "' " : '' ;
			var documentType:String 	= Number(_object['documentType'])    ? " AND DOCUMENT_TYPE = '" 	+ _object['documentType'] 	+ "' " : '' ;
			var payType:String 			= Number(_object['payType'])         ? " AND PAY_TYPE = '" 			+ _object['payType'] 		+ "' " : '' ;
			
			var _filter:String = idAccount + idDepartament + idGroup + idCategory + documentType + payType;
			
			var _WHERE:String = " " +
				"( DATE_END   >= '"+dateStartCurrent+" 00:00:00' AND DATE_END   <= '"+dateEndCurrent+" 23:59:59' ) OR " + 
				"( DATE_FINAL >= '"+dateStartCurrent+" 00:00:00' AND DATE_FINAL <= '"+dateEndCurrent+" 23:59:59' )" + 
				"" + _filter;

			var _COLUMNS:Array = [
				"*, IF(VALUE_IN > 0, '1', '0') as FININ, " +
				"(select NAME   from dbd_client 			where dbd_client.ID            = ID_CLIENT					    ) as NAME_CLIENT ",
				"(select NAME 	from dbd_departament 		where dbd_departament.ID       = ID_DEPARTAMENT					) as NAME_DEPARTAMENT ",
				"(select NAME 	from dbd_group 				where dbd_group.ID             = ID_GROUP						) as NAME_GROUP ",
				//"(select NAME 	from dbd_category 			where dbd_category.ID          = ID_CATEGORY					) as NAME_CATEGORY ",
				"(select NAME 	from dbd_financial_account 	where dbd_financial_account.ID = ID_FINANCIAL_ACCOUNT		    ) as NAME_FINANCIAL_ACCOUNT ",

				"(select f.NUMBER_FINAL_PAY from dbd_financial as f where f.ID = dbd_financial.ID_PAY_PART limit 1 ) as THIS_IS_NUMBER_FINAL_PAY ",

				//pendencias
				"coalesce((select COUNT( ID ) 												from dbd_financial where VISIBLE = '1' AND ACTIVE = '1' "+idAccount+" ),0) as ROWS_ACTIVE_1 ",
				"coalesce((select SUM( IF(VALUE_IN_PAY>0, VALUE_IN_PAY, VALUE_IN) ) 		from dbd_financial where VISIBLE = '1' AND ACTIVE = '1' "+idAccount+" ),0) as VALUE_IN_ACTIVE_1 ",
				"coalesce((select SUM( IF(VALUE_OUT_PAY>0,VALUE_OUT_PAY,VALUE_OUT) ) 		from dbd_financial where VISIBLE = '1' AND ACTIVE = '1' "+idAccount+" ),0) as VALUE_OUT_ACTIVE_1 ",

				//valor + juro + multa - desconto de pontualidade
				" CASE WHEN DATEDIFF(NOW(),dbd_financial.DATE_END) > 0 THEN ROUND((dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT) * (1 + ((dbd_financial.FINE_PERCENT/100)/dbd_financial.FINE_PERCENT_TIME) * DATEDIFF(NOW(),dbd_financial.DATE_END) )+(dbd_financial.FINE_VALUE)+(dbd_financial.FINE_VALUE_PERCENT/100*(dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT)),2) ELSE ROUND((dbd_financial.VALUE_IN + dbd_financial.VALUE_OUT)-dbd_financial.DISCOUNT_PUNCTUALITY,2) END as VALUE_FINAL ",

				//valor de todas as receitas do dia
				"(select round(SUM(VALUE_IN_PAY),2) 		from dbd_financial where "+_WHERE+"								) as TOTAL_TODAY_IN ",
				//valor de todas as despesas do dia
				"(select round(SUM(VALUE_OUT_PAY),2) 		from dbd_financial where "+_WHERE+"								) as TOTAL_TODAY_OUT ",
				//A soma de toda movimentação anterior a hoje, saldo de ontem
				"(select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where DATE_FINAL <= '"+dateStartYesterday+" 23:59:59' "+idAccount+" ) as TOTAL_BEFORE ",
				"(select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where DATE_END   <= '"+dateStartYesterday+" 23:59:59' "+idAccount+" ) as TOTAL_BEFORE_END ",
				//somas de todas as movimentações 
				"(select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where DATE_FINAL <= '"+dateEndCurrent+" 23:59:59' "+idAccount+" ) as TOTAL_AFTER ",
				"(select round(SUM(VALUE_IN_PAY)-SUM(VALUE_OUT_PAY),2) from dbd_financial where DATE_END   <= '"+dateEndCurrent+" 23:59:59' "+idAccount+" ) as TOTAL_AFTER_END "
				
			];

			//var ord:Array = ['FININ desc','PAY_TYPE','FLAG_CARD','DOCUMENT_TYPE']
			var ord:Array = [(_object['orderBy']?_object['orderBy']+',':'')+'FININ desc','DATE_END','NUMBER_FINAL_PAY','ID_DEPARTAMENT','ID_FINANCIAL_ACCOUNT','PAY_TYPE','FLAG_CARD','NUMBER_LETTER','NUMBER','DATE_FINAL asc','DATE_END'];

			//OLD
			//_sql = new gnncSql().__SELECT(new table_financial(),false,_COLUMNS,null,null,[_WHERE],null,['DATE_END','NUMBER_LETTER','NUMBER','DATE_FINAL'],false);
			//_sql = new gnncSql().__SELECT(new table_financial(),false,_COLUMNS,null,null,[_WHERE],null,['FININ desc','PAY_TYPE','FLAG_CARD','DOCUMENT_TYPE'],false);
			//NEW, BUT no finished
			_sql = new gnncSql().__SELECT(new table_financial(),false,_COLUMNS,null,null,[_WHERE],null,ord,false);
						
		}

		
	}
}