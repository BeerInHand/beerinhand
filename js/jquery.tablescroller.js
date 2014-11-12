(function($) {
	$.extend({
		tablescroller: new function() {
			this.defaults = {
				backgroundColor: "#C3D3E3",
				borderColor: "#003B5C",
				borderStyle: "solid",
				borderWidth: 0,
				className: "bih-grid",
 				classCaption: "bih-grid-caption ui-widget-header",
 				classHover: "bih-grid-row-hover",
				filename: "",
				height: 0,
				id: "",
				lock: 0,
				print: true,
				pipeDataCB: false,
				sort: false,
				splitColor: "#003B5C",
				splitWidth: 1,
				width: 0,
				debug: false
			};
			/* debuging utils */
			benchmark = function(s,d) {
				var t = new Date().getTime() - d.getTime();
				t = t.toString();
				while (t.length<6) t="0"+t;
				log(t + " ms : "+ s);
			}
			log = function(s) {
				if (typeof console != "undefined" && typeof console.debug != "undefined") {
					console.log(s);
				} else {
					alert(s);
				}
			}
			scrollToTop = function(top) {
				$('html,body').animate({scrollTop: top}, 500);
			}
			pipeData = function(table, querystring, callback) {
				var my = table[0].setup;
				var $tsc = my.$divCaption.clone();
				var $tsh = my.$tabScrollHead.find("thead:first").clone();
				var $tsb = my.$tabScrollBody.find("tbody:first").clone();
				if (my.hasFoot) var $tsf = my.$tabScrollFoot.find("tfoot:first").clone();
				$tsc.find("span").remove(); // REMOVE CAPTION BUTTONS
				$tsc = $("<caption></caption>").append($tsc.html());
				$tsh.find("br").remove();
				$tsb.find("tr").filter(function() { return $(this).css("display")=="none"}).remove(); // REMOVE "HIDDEN" ROWS USING DISPLAY CAUSE THE BODY IS NOT ATTACHED TO DOM
				$tsb.find("tr.trremove").remove();
				var $clone = $("<table border=1 cellspacing=0 cellpadding=2></table>");
				$clone.append($tsc);
				$clone.append($tsh);
				$clone.append($tsb);
				if (my.hasFoot) $clone.append($tsf);
				$clone.find(".juiButton-icon-only").remove(); // REMOVE ANY ELEMENT WITH CLASS ICON
				// REMOVE ANY <A>, <IMG>, <ABBR> TAGS IN THE TABLE DATA
				$clone.find("button").replaceWith(function() { return this.title;});
				$clone.find("img").replaceWith(function() { return this.title;});
				$clone.find("abbr").replaceWith(function() { return this.title;});
				$clone.find("a").replaceWith(function() { return this.innerHTML;});
				$clone = $("<div></div>").append($clone);
				var $txt = $("<textarea id='txtPipeData' name='txtPipeData'></textarea>");
				var $frm = $("<form id='frmPipeData' name='frmPipeData' action='/g3/common/pipedata.cfm?"+querystring+"' target='pipeData' method='post'><input type=text name='txtPipeFile' value='"+my.filename+"'></form>").append($txt);
				$("body").append($frm);
				if (callback) {
					callback($txt, $clone);
				} else {
					var html =  $clone.html();
					html = html.replace(/\s+/ig," ").replace(/>\s+/ig,">");
					$txt[0].value = html.replace(/( style| class)=\s*"[^"]*"/ig, " ");
				}
				$frm[0].submit();
				$clone.remove();
				$frm.remove();
			}
			this.pipeData = pipeData;
			scrollbarSize = function() {
				var $div = $('<div style="width:100px;height:100px;overflow-y:scroll;"><div style="width:20px;height:200px;"></div>');
				$("body").append($div);
				var sbw = 100 - $div[0].clientWidth;
				$div.remove();
				return sbw;
			}
			calcRealWidth = function ($e1, $e2) {
				var w1 = $e1.width();
				var bp1 = $e1.outerWidth() - w1; // size of border+pading
				var bp2 = $e2.outerWidth() - $e2.width(); // size of border+pading
				var diff = bp1 - bp2; // diff between border/padding of the elements
				//$e2.width(w1+diff);
				return w1+diff;
			}
			filtercolumn = function($tsb, col, find, match) {
				var re = new RegExp(find,"i");
				var my = $tsb[0].setup;
				with (my) {
					$tabScrollBody.find("tbody:first").find("> tr").each(
						function(row) {
							var $row = $(this);
							var $td = $row.find("td").eq(col);
							var val = $td.text();
							if (!re.test(val)) {
								$row.hide();
								if (lock) $tabLockBody.find("tbody:first").find("> tr").eq(row).hide();
							} else {
								// if ($row.css("display")=="none")
								$row.show();
								$td.removeClass("filter");
								$td.addClass("filtered");
								if (lock) {
									$row = $tabLockBody.find("tr").eq(row);
									$td = $row.find("td").eq(col);
									$row.show();
									$td.removeClass("filter");
									$td.addClass("filtered");
								}
							}
						}
					);
					if (sort) {
						$.tablesorter.applyWidget($tabScrollBody[0]);
						if (lock) $.tablesorter.applyWidget($tabLockBody[0]);
					}
					$.tablescroller.resizeControl($tabScrollBody);
				}
			}
			sizeTR = function(setup, $tr) {
				$tr.find("> td").each(
					function(column) {
						this.style.width = setup.cwb[column] + "px";
					}
				);
			}
			this.sizeTR = sizeTR;
			resizeControl = function(table, resetWidths, skipSort) {
				var my = table[0].setup;
				with (my) {
					if (resetWidths) {
						sizeTR(my, $tabScrollBody.find(">tbody:first").find(">tr:visible:first"));
						if (!skipSort && sort) $.tablesorter.applyWidget($tabScrollBody[0]);
						if (lock) {
							sizeTR(my, $tabLockBody.find(">tbody:first").find(">tr:visible:first"));
							if (!skipSort && sort) $.tablesorter.applyWidget($tabLockBody[0]);
						}
					}
					var bodyHeight = $tabScrollBody.outerHeight();
					var tableHeight = headHeight + bodyHeight + footHeight;
					var fullHeight = (height==0 || height>tableHeight+scrollbarSize);
					var fullWidth = (width==0 || width>tableWidth+scrollbarSize);
					var wrapHeight = Math.min(height, tableHeight) || tableHeight;
					var sbRight = (tableHeight > wrapHeight) * scrollbarSize;
					var wrapWidth = Math.min(width, tableWidth) || tableWidth;
					var sbBottom = (tableWidth > wrapWidth) * scrollbarSize;
					// CALC HEIGHTS
					var dbHeight;
					var dlbHeight;
					var dfHeight = footHeight;
					if (!fullHeight && height) { // GOT A HEIGHT, CONSTRAINT TO DIMENSIONS
						dbHeight = wrapHeight - headHeight - footHeight;
						if (hasFoot) { // IF WE HAVE A FOOT, SHRINK BODY AND INCREASE FOOT TO FIT SB IF THERE IS ONE
							dbHeight -= sbBottom;
							dfHeight += sbBottom;
							dlbHeight = dbHeight;
						} else {
							dlbHeight = dbHeight - sbBottom;
						}
					} else { // NO HEIGHT PASSED, ALLOW TO EXPAND AS NEEDED
						dbHeight = bodyHeight;
						wrapHeight += sbBottom;
						if (hasFoot) {
							dfHeight += sbBottom;
						} else {
							dbHeight += sbBottom;
						}
					}
					// CALC WIDTHS
					var dbWidth = wrapWidth - divLockWidth;
					var dhWidth = dbWidth;
					if (!fullWidth && width) { // GOT A WIDTH, CONSTRAINT TO DIMENSIONS
						dhWidth -= sbRight;
					} else { // NO WIDTH PASSED, ALLOW TO EXPAND AS NEEDED
						wrapWidth += sbRight;
						dbWidth += sbRight;
					}
					// RESIZE DIVS
					$divWrapper.css({"height": wrapHeight + captionHeight, "width": wrapWidth});
					if (hasCaption) $divCaption.css({"width": wrapWidth});
					$divScrollWrap.css({"height": wrapHeight});
					$divScrollHead.css({"width": dhWidth});
					$divScrollBody.css({"height": dbHeight, "width": dbWidth});
					if (wrapHeight+5 > tableHeight && wrapWidth+5 > tableWidth) {
						$divScrollBody.css({"overflow": "hidden"});
					} else {
						$divScrollBody.css({"overflow": "auto"});
					}
					if (hasFoot) $divScrollFoot.css({"width": dhWidth, "height": dfHeight});
					if (lock) {
						$divLockWrap.css({"height": wrapHeight});
						$divLockBody.css({"height": dlbHeight});
						if (hasFoot) $divLockFoot.css({"height": dfHeight});
					}
				}
			}
			this.resizeControl = resizeControl;

			this.construct = function(settings) {
				return this.each(
					function() {
						if (!this.tHead || !this.tBodies) return;
						var $origTable = $(this);
						this.setup = {};
						$.extend(this.setup, $.tablescroller.defaults, settings);
						var setup = this.setup;
						if (setup.debug) var debugTimerTotal = new Date();
						if (setup.debug) console.time("TableScroller: Total Setup Time");
						if (setup.debug) console.time("TableScroller: Initialization");
						// CHECK FOR METADATA IN THE TABLE CLASS
						if ($.metadata && $origTable.metadata()) {
							for (var prop in $origTable.metadata()) {
								if (prop in setup) setup[prop]=$origTable.metadata()[prop];
							}
						}
						setup.scrollbarSize = scrollbarSize();
						setup.captionHeight = 0;
						setup.headHeight = 0;
						setup.footHeight = 0;
						setup.divLockWidth = 0;
						// STORE OBJECTS FOR FASTER ACCESS
						var $origHead = $origTable.find("> thead:first");
						var $origBody = $origTable.find("> tbody:first");
						var $origFoot = $origTable.find("> tfoot:first");
						var $origCaption = $origTable.find("caption");
						setup.hasFoot = ($origFoot.length>0);
						setup.hasCaption = ($origCaption.length>0);
						// IF WE HAVE A CAPTION, MOVE IT TO IT'S OWN DIV
						if (setup.hasCaption) {
							setup.$divCaption = $("<div>"+$origCaption.html()+"</div>").attr("id", "divCaption"+setup.id);
							setup.$divCaption.addClass(setup.classCaption);
							$origCaption.remove();
						}
						// IF ANY TD's ARE EMPTY, FILL WITH &nbsp; -- MAINLY IE7 PROBLEM
						$origTable.find("td:empty").html("&nbsp;");
						// SET THE SORTABLE CLASS ON THE THEAD
//						if (setup.sort) $origHead.addClass(setup.className);
						if (setup.debug) console.timeEnd("TableScroller: Initialization");
						if (setup.debug) console.time("TableScroller: Fixed Table Widths");
						// SAVE THE TOTAL WIDTH OF THE FULLY DISPLAY TABLE
						setup.tableWidth = $origTable[0].offsetWidth;
						if (setup.width==0 || (setup.tableWidth+setup.scrollbarSize)<=setup.width) setup.lock = 0; // DON'T LOCK ANYTHING IF WE CAN FIT
						// WHILE THE ORIG TABLE IS INTACT, FIX SOME WIDTHS
						$origTable.css({"width": setup.tableWidth});
//						$origTable.css({"white-space": "nowrap"});
//						$origTable.css({"table-layout": "fixed"});
						if (setup.debug) console.timeEnd("TableScroller: Fixed Table Widths");
						if (setup.debug) console.time("TableScroller: Fixed Head Column Widths");
						// FIX THE WIDTH OF EACH THEAD CELL AND THE FIRST ROW OF TBODY/TFOOT
						// DO THIS IN TWO PASSES, ONCE FOR THE HEAD WHERE WE STORE THE VALUE, THEN AGAIN ON THE BODY WHERE WE SET THE VALUES
						var $bodyrow1 = $origBody.find("tr:first");
						setup.cwb = [];
						setup.cwh = [];
						if (setup.hasFoot) {
							var $footrow1 = $origFoot.find("tr:first");
							var cwf = [];
						}
						var $trlastth = $origHead.find("tr:last th");
						$trlastth.each( // 3 PASSES, 1ST SAVES WIDTHS
							function(column) {
								var $th = $(this);
								if (setup.sort) {
									if ($th.hasClass("icon")) $th.addClass("{sorter: false}");									 
									var isSortable = ($.metadata && $th.metadata() && $th.metadata().sorter);
									if (typeof isSortable!="undefined" && !isSortable) {
										$th.addClass("bih-grid-sort-no");
									}
								}
								setup.cwh[column] = $th.width();
							}
						);
						$origHead.hide();
						$trlastth.each( // NEXT PASS SETS WIDTHS ON HIDDEN HEAD
							function(column) {
								var $th = $(this);
								$th.css("width", setup.cwh[column]);
							}
						);
						$origHead.show();
						$trlastth.each( // FINAL PASS SAVES BODY COLUMN WIDTHS
							function(column) {
								var $th = $(this);
								setup.cwb[column] = calcRealWidth($th, $bodyrow1.find(">td").eq(column));
								if (setup.hasFoot) cwf[column] = calcRealWidth($th, $footrow1.find(">th").eq(column));
							}
						);
						if (setup.debug) console.timeEnd("TableScroller: Fixed Head Column Widths");
						if (setup.debug) console.time("TableScroller: Fixed Body Row Heights");
						// IF THERE IS A LOCK, FIX THE HEIGHT OF THE LAST TD IN EACH TR TO KEEP HEIGHTS SAME ACROSS DIVS
						if (setup.lock) {
							var rh = [];
							$origBody.find("tr").each(
								function(row) {
									rh[row] = $(this).outerHeight(true);
								}
							);
						}
						// MOVE THE VARIOUS PEICES TO AN UNDISPLAYED TABLE FOR HOLDING AND RESIZING
						var $tempTable = $("<table></table>").append($origHead).append($origBody).append($origFoot);
						if (setup.lock) {
							$origBody.find("tr").each(
								function(row) {
									this.style.height = rh[row] + "px";
								}
							);
						}
						if (setup.debug) console.timeEnd("TableScroller: Fixed Body Row Heights");
						if (setup.debug) console.time("TableScroller: Fixed Body Column Widths");
						$bodyrow1.find("> td").each(
							function(column) {
								this.style.width = setup.cwb[column] + "px";
								if (setup.hasFoot) $footrow1.find(">th").eq(column).width(cwf[column]);
							}
						);
						if (setup.debug) console.timeEnd("TableScroller: Fixed Body Column Widths");
						if (setup.debug) console.time("TableScroller: Scroll Div Creation");
						// FIX THE HEIGHT OF THE HEAD/FOOT
						$origHead.css({"height": $origHead.height()});
						if (setup.hasFoot) $origFoot.css({"height": $origFoot.height()});
						// CREATE THE DIVS AND TABLES TO HOLD THE VARIOUS PIECES OF THE ORIGINAL TABLE
						setup.$divWrapper = $("<div></div>").attr("id", "divWrapper"+setup.id).addClass("divWrapper");
						setup.$divScrollWrap = $("<div></div>").attr("id", "divScrollWrap"+setup.id).addClass("divScrollWrap");
						setup.$divScrollHead = $("<div></div>").attr("id", "divScrollHead"+setup.id).addClass("divScrollHead").css({"overflow": "hidden"});
						setup.$divScrollBody = $("<div></div>").attr("id", "divScrollBody"+setup.id).addClass("divScrollBody").css({"overflow": "auto"});
						setup.$divWrapper.css({"overflow": "hidden"});
						// APPLY BORDER/BACKGROUND COLOR TO WRAPPER DIV
						if (setup.borderWidth) {
							setup.$divWrapper.css({"border": setup.borderColor + " " + setup.borderStyle + " " + setup.borderWidth + "px"});
						}
						// CREATE FOOT DIV IF NEEDED AND SET UP SCROLLBARS VIA OVERFLOW
						if (setup.hasFoot) {
							setup.$divScrollFoot = $("<div></div>").attr("id", "divScrollFoot"+setup.id).addClass("divScrollFoot").css({"overflow-y": "hidden","overflow-x": "auto"});
							setup.$divScrollBody.css({"overflow-y": "auto","overflow-x": "hidden"});
						} else {
							setup.$divScrollBody.css({"overflow": "auto"});
						}
						setup.$tabScrollHead = $origTable.clone().attr("id","tabScrollHead"+setup.id).css({"margin": "0", "padding": "0"});
						setup.$tabScrollBody = $origTable.attr("id","tabScrollBody"+setup.id).css({"margin": "0", "padding": "0"});
						if (setup.hasFoot) setup.$tabScrollFoot = $origTable.clone().attr("id","tabScrollFoot"+setup.id).css({"margin": "0", "padding": "0"});
						// INSERT NEW DIV BEFORE ORIGINAL TABLE
						$origTable.before(setup.$divWrapper);
						// REARRANGE THE DIVS AND TABLES AND MOVE THE HEAD/BODY/FOOT BACK TO PROPER TABLES
						setup.$divWrapper.append(setup.$divScrollWrap);
						setup.$divScrollWrap.append(setup.$divScrollHead);
						setup.$divScrollWrap.append(setup.$divScrollBody);
						if (setup.hasFoot) setup.$divScrollWrap.append(setup.$divScrollFoot);
						setup.$divScrollHead.append(setup.$tabScrollHead.append($origHead));
						setup.$divScrollBody.append(setup.$tabScrollBody.append($origBody));
						if (setup.hasFoot) setup.$divScrollFoot.append(setup.$tabScrollFoot.append($origFoot));
						// REMOVE THE TEMP TABLE FROM THE DOM
						$tempTable.remove();
						if (setup.debug) console.timeEnd("TableScroller: Scroll Div Creation");
						if (setup.debug) console.time("TableScroller: Lock Div Creation");
						// IF ANY COLUMNS ARE LOCKED, SET UP THE LOCKING DIV
						if (setup.lock) {
							setup.$divLockWrap = $("<div></div>").attr("id","divLockWrap"+setup.id).addClass("divLockWrap");
							setup.$divLockHead = $("<div></div>").attr("id","divLockHead"+setup.id).addClass("divLockHead");
							setup.$divLockBody = $("<div></div>").attr("id","divLockBody"+setup.id).addClass("divLockBody");
							if (setup.hasFoot) setup.$divLockFoot = $("<div></div>").attr("id","divLockFoot"+setup.id).addClass("divLockFoot");
							setup.$tabLockHead = setup.$tabScrollHead.clone(true).attr("id","tabLockHead"+setup.id);
							setup.$tabLockBody = setup.$tabScrollBody.clone().attr("id","tabLockBody"+setup.id);
							if (setup.hasFoot) setup.$tabLockFoot = setup.$tabScrollFoot.clone().attr("id","tabLockFoot"+setup.id);
							// REARRANGE THE DIVS AND TABLES AND MOVE THE HEAD/BODY/FOOT TO PROPER TABLES
							setup.$divWrapper.prepend(setup.$divLockWrap);
							setup.$divLockWrap.append(setup.$divLockHead);
							setup.$divLockWrap.append(setup.$divLockBody);
							if (setup.hasFoot) setup.$divLockWrap.append(setup.$divLockFoot);
							setup.$divLockHead.append(setup.$tabLockHead);
							setup.$divLockBody.append(setup.$tabLockBody);
							if (setup.hasFoot) setup.$divLockFoot.append(setup.$tabLockFoot);
							if (setup.splitWidth) {
								setup.$divLockWrap.css({"border-right": setup.splitColor + " solid " + setup.splitWidth + "px"});
							}
							// HIDE ALL LOCKED COLUMNS IN SCROLL AREA SINCE THEY APPEAR IN THE LOCK AREA
							// AGAIN, WE DO THIS IN TWO STEPS ONCE TO CALC AND AGAIN TO SET
							var colLockWidth = 0;
							$origHead.find("th").each( // CALC WIDTH OF LOCKED PORTION
								function(column) {
									if (column < setup.lock) {
										colLockWidth += $(this).outerWidth();
									}
								}
							);
							$origHead.find("tr").each( // NEED TO LOOP EACH TR SO "COLUMN" IS CORRECT ON MULTI-ROW HEADERS
								function() {
									$(this).find("th").each( // NOW HIDE THE LOCKS
										function(column) {
											if (column < setup.lock) {
												$(this).hide();
												$("td:nth-child("+(column+1)+")", $origBody).hide(); // nth-child is NOT zero based
												if (setup.hasFoot) $("th:nth-child("+(column+1)+")", $origFoot).hide();
											}
										}
									);
								}
							);
							// SET LOCKED DIV TO THE TOTAL WIDTH OF THE DISPLAYED COLUMNS
							setup.$divLockWrap.css({"width": colLockWidth});
							// THEN READ IT BACK IN CASE BORDERS/PADDING HAVE AFFECTED WIDTH
							setup.divLockWidth = setup.$divLockWrap.attr("offsetWidth");
							// SET THE WIDTH OF THE SCROLL TABLE WITHOUT THE HIDDEN COLUMNS
							var shownWidth = setup.tableWidth - colLockWidth;
							setup.$tabScrollHead.css({"width": shownWidth});
							setup.$tabScrollBody.css({"width": shownWidth});
							if (setup.hasFoot) setup.$tabScrollFoot.css({"width": shownWidth});
							setup.$divLockWrap.css({"overflow": "hidden", "float": "left"});
							setup.$divLockBody.css({"overflow": "hidden"});
							setup.$divScrollWrap.css({"float": "left"});
						} // END LOCK COLUMN SETUP
						if (setup.debug) console.timeEnd("TableScroller: Lock Div Creation");
						if (setup.debug) console.time("TableScroller: Caption Creation");
						// IF WE HAD A TABLE CAPTION, APPEND TO THE TOP OF DIVWRAPPER AND STORE IT'S HEIGHT
						if (setup.hasCaption) {
							setup.$divCaption.css({"width": setup.tableWidth, "position": "relative"});
							setup.$divWrapper.prepend(setup.$divCaption);
							setup.captionHeight = Math.max(26,setup.$divCaption.attr("offsetHeight"));
							setup.$divCaption.css({"height": setup.captionHeight});
							var imgTop = Math.max(0,(setup.captionHeight-24)/2);
							var right = 1;
							var btnIco = "<button class='liveHover juiButton-icon-only ui-state-default ui-widget ui-corner-all ui-button ui-button-icon-only' type='button'><span class='ui-button-icon-primary ui-icon bih-icon'></span><span class='ui-button-text'>&nbsp;</span></button>";
							if (setup.filename != '') {
								var $imgXLS = $(btnIco).attr("id","btnXLS"+setup.id);
								$imgXLS.click(function() {pipeData(setup.$tabScrollBody,'excel_export=1',setup.pipeDataCB);});
								$imgXLS.attr("title","Export to Excel").css({"position": "absolute", "top": imgTop, "right": right});
								$imgXLS.find("span:first").addClass("bih-icon-excel");
								right += 25;
								setup.$divCaption.append($imgXLS);
							}
							if (setup.print) {
								var $imgPrint = $(btnIco).attr("id","btnPrint"+setup.id);
								$imgPrint.click(function() {pipeData(setup.$tabScrollBody,'print=1',setup.pipeDataCB);});
								$imgPrint.attr("title","Print").css({"position": "absolute", "top": imgTop, "right": right});
								$imgPrint.find("span:first").addClass("bih-icon-print");
								right += 25;
								setup.$divCaption.append($imgPrint);
							}
/*
							var left = 1;
							var $imgScrollTop = $(btnIco).attr("id","btnScroll"+setup.id);
							$imgScrollTop.click(function() {scrollToTop(setup.$divCaption.offset().top)});
							$imgScrollTop.attr("title","Scroll into View").css({"position": "absolute", "top": imgTop, "left": left});
							$imgScrollTop.find("span:first").addClass("bih-icon-top");
							left += 25;
							setup.$divCaption.append($imgScrollTop);
*/
						}
						if (setup.debug) console.timeEnd("TableScroller: Caption Creation");
						if (setup.debug) console.time("TableScroller: Resize Control");
						// WITH HEAD/FOOT IN NEW TABLE, STORE TABLE HEIGHTS, THESE SHOULD NOT CHANGE
						setup.headHeight = setup.$tabScrollHead.outerHeight();
						if (setup.hasFoot) setup.footHeight = setup.$tabScrollFoot.outerHeight();
						// WITH ALL OBJECTS CREATED, RESIZE EVERYTHING TO FIT
						resizeControl($origTable, true, true);
						if (setup.debug) console.timeEnd("TableScroller: Resize Control");
						if (setup.debug) console.time("TableScroller: Scroll Events");
						// SETUP SCROLL EVENTS ON EITHER BODY OR FOOT DEPENDING ON EXISTENCE OF FOOT
						setup.$divScrollBody.scroll(
							function() {
								if (setup.$divLockBody) {
									setup.$divLockBody.scrollTop(setup.$divScrollBody.scrollTop());
								}
								var left = 0;
								if (setup.hasFoot) {
									left = setup.$divScrollFoot.scrollLeft();
									setup.$divScrollBody.scrollLeft(left);
								} else {
									left = setup.$divScrollBody.scrollLeft();
								}
								setup.$divScrollHead.scrollLeft(left);
							}
						);
						if (setup.hasFoot) {
							setup.$divScrollFoot.scroll(
								function() {
									setup.$divScrollBody.scroll();
								}
							);
						}
						if (setup.debug) console.timeEnd("TableScroller: Scroll Events");
						if (setup.sort) {
							if (setup.debug) console.time("TableScroller: Setup Scroll Div Sorting");
							setup.$tabScrollBody.prepend($origHead);
							setup.$tabScrollBody.tablesorter(setup.sort);
							setup.$tabScrollHead.append($origHead);
							if (setup.debug) console.timeEnd("TableScroller: Setup Scroll Div Sorting");
							if (setup.lock) {
								if (setup.debug) console.time("TableScroller: Setup Lock Div Sorting");
								var $cloneHead = setup.$tabLockHead.find("thead:first");
								setup.$tabLockBody.prepend($cloneHead);
								setup.$tabLockBody.tablesorter(setup.sort);
								setup.$tabLockHead.append($cloneHead);
								setup.$tabScrollBody.bind("sortEnd",
									function() {
										var oSL = this.config.sortList;
										var cSL = setup.$tabLockBody[0].config.sortList;
										if (oSL!=cSL) setup.$tabLockBody.trigger("sorton",[oSL]);
									}
								);
								setup.$tabLockBody.bind("sortEnd",
									function() {
										var cSL = this.config.sortList;
										var oSL = setup.$tabScrollBody[0].config.sortList;
										if (oSL!=cSL) setup.$tabScrollBody.trigger("sorton",[cSL]);
									}
								);
								if (setup.debug) console.timeEnd("TableScroller: Setup Lock Div Sorting");
							}
						}
						// MOUSE OVER HIGHLIGHT EACH TR
						if (setup.debug) console.time("TableScroller: Setup MouseOver Events");
						setup.$tabScrollBody.find("tbody:first").find("> tr").hover(
							function() {
								$(this).addClass(setup.classHover);
								if (setup.lock) setup.$tabLockBody.find("tbody:first").find("tr").eq(this.rowIndex).addClass(setup.classHover);
							},
							function() {
								$(this).removeClass(setup.classHover);
								if (setup.lock) setup.$tabLockBody.find("tbody:first").find("tr").eq(this.rowIndex).removeClass(setup.classHover);
							}
						);
						if (setup.lock) {
							setup.$tabLockBody.find("tbody:first").find("> tr").hover(
								function() {
									$(this).addClass(setup.classHover);
									setup.$tabScrollBody.find("tr").eq(this.rowIndex).addClass(setup.classHover);
								},
								function() {
									$(this).removeClass(setup.classHover);
									setup.$tabScrollBody.find("tr").eq(this.rowIndex).removeClass(setup.classHover);
								}
							);
						}
						if (setup.debug) console.timeEnd("TableScroller: Setup MouseOver Events");
						if (setup.debug) console.timeEnd("TableScroller: Total Setup Time");
						if (setup.debug) benchmark("TableScroller Benchmark", debugTimerTotal);
					}// END OF TABSCROLLER FUNCTION
				);
			} // END OF CONSTRUCT FUNCTION
		}
	});
	// extend plugin scope
	$.fn.extend({
		tablescroller: $.tablescroller.construct
	});

})(jQuery);
